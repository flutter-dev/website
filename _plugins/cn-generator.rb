module Jekyll
  class CNGenerator < Generator
    safe true
    PREFIX = "zh_CN"

    def generate(site)
      lang = site.config["lang"] || "en"
      if !PREFIX.eql?(lang)
        return
      end
      puts "Configuration file: 启用本地化文件，中文"
      totalNum = site.pages.size
      currentNum = 0
      site.pages.each do |page|
        newPath = "#{site.source}/#{PREFIX}/#{page.path}"
        isFileExist = File.exist?(newPath)
        if isFileExist
          site.pages.delete(page)
          currentNum += 1
        end
      end
      completeP = currentNum * 100 / totalNum.to_f
      completePStr = format('%.2f', completeP)
      puts "=================== 当前翻译进度：#{currentNum}/#{totalNum}，占比：#{completePStr}%"
      # site.pages.each do |page|
      #   puts "#{page.url} => #{page.path}"
      # end
    end
  end
end