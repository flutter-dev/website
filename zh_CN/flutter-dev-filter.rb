require 'open-uri'
require 'Nokogiri'
# ARGV.first
# "/Users/gaopengsheng/Desktop/website"
path = ARGV.first
issues = []     # Translating articles
total = {}      # All articles in /website directory
zh_CNs = []     # Translated articles
dirs = []       # Directories
exceptions = {} # Exceptions: directories/file name error/path error
redundance = [] # Redundance: which exists in /zh_CN but not in /website

# 1. issues
url = "https://github.com/flutter-dev/website/issues"
Nokogiri::HTML(open(url)).xpath('//div[@class="float-left col-9 lh-condensed p-2"]/a/text()').each do |item|
  # item转成string去除空格和分隔符，去除开头 '/'
  temp = item.to_s.strip.gsub(/^\/+/, '')
  # issue文件必须在website文件夹中，所以如果不包含 '.md' 或者不以 'website' 开头，则归为异常文件
  if !(temp.include? ".md") || (temp !~ /^\/?website/)
    exceptions[temp] = nil if !exceptions.include?(temp)
  else
    issues << temp if !issues.include?(temp)
  end
end

# 2. 本地website目录
Dir.chdir(path)
Dir.glob(%w(**/*.md)) do |item|
    if item =~ /^zh_CN\// # 2.1 zh_CNs文件夹
      zh_CNs << "website/#{item.gsub(/^zh_CN\//,"")}"
    else                  # 2.2 除去zh_CNs文件夹的全部文件
      total[item.sub(/\.md$/,"").gsub(/[\W_]/,"")] = "website/#{item}"  
    end
end

# 3. 冗余的文件（只存在于zh_CNs，在website根目录找不到的文件）
redundance = zh_CNs - total.values

# utilities

# 传入去除后缀和符号的绝对文件名，遍历total返回含有该文件名的key对应的value
hasFile = ->(elem, arr){
  arr.map do |key, value|
     if key.to_s =~ /#{elem}$/ 
       # arr.delete(key)
      return {key => value}
    end
  end
  return nil
}

# 4. 处理异常
exceptions.keys.map do |item|
  abso = item.sub(/.*\//,"").sub(/\.md$/,"").gsub(/[\W_]/,"")     # 1. 去除.md和所有符号只保留文件名
  rela = item.sub(/website/,"").sub(/\.md$/,"").gsub(/[\W_]/,"")  # 2. 去除website前缀，.md后缀和所有符号，保留除website的路径
  
  if File.directory? "#{path.gsub(/website$/,"")}#{item}"   # 4.1 目录不是异常文件
    dirs << item
    exceptions.delete(item)
  elsif total.keys.include?rela                             # 4.2 文件名异常
    exceptions[item] = "命名异常，更正：#{total[rela]}"
    total.delete(rela)
  elsif hasFile.call(abso, total)                           # 4.3 文件路径异常
    exceptions[item] = "路径异常，更正：#{hasFile.call(abso, total).values.first}"
    total.delete(hasFile.call(abso, total).keys.first)
  else                                                      # 4.4 找不到对应文件
    exceptions[item] = "找不到对应文件"
  end
end

# 5. 处理文件夹
dirs.map do |dir|
  dir = dir.sub(/website/,"").gsub(/[\W_]/,"")
  total.keys.map do |key|
    if key =~ /^#{dir}/
      total.delete(key)
    end
  end
end

# 7. 可翻译文件
result = total.values - issues - zh_CNs

# 8. 输出
puts <<LOG
1. 当前open的issues共 \033[32m#{issues.size + exceptions.size + dirs.size}\033[0m 个,其中文件夹 \033[32m#{dirs.size}\033[0m 个，异常文件 \033[31m#{exceptions.size}\033[0m 个：
LOG

exceptions.to_a.each_with_index do |obj, i|
  print "\033[41;36m#{i+1}) #{obj[0]}\033[0m\n"
  print "#{obj[1]}\n"
end
puts "\n2. 冗余文件（只存在于zh_CN，在website根目录找不到的文件）共 \033[31m#{redundance.size}\033[0m 个："
redundance.each_with_index do |obj, i|
  print "#{i+1}) #{obj.gsub(/website/,"zh_CN")}\n"
end
puts "\n3. 未翻译的文件共 \033[32m#{result.size}\033[0m 个："
result.each_with_index do |obj, i|
  print "#{i+1})\t#{obj}\n"
end