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
<<<<<<< HEAD
      translatedNum = 0
      deleteList = []
=======
>>>>>>> parent of 1238fb1... 修改cn-generator.rb，新增对翻译文件数量和进度的统计。
      site.pages.each do |page|
        newPath = "#{site.source}/#{PREFIX}/#{page.path}"
        isFileExist = File.exist?(newPath)
        if isFileExist
<<<<<<< HEAD
          deleteList << page
          translatedNum += 1
        end
      end
      site.pages -= deleteList
      totalNum = site.pages.size
      completeP = translatedNum * 100 / totalNum.to_f
      completePStr = format('%.2f', completeP)
      puts "=================== 当前翻译进度：#{translatedNum}/#{totalNum}，占比：#{completePStr}%"
=======
          site.pages.delete(page)
        end
      end
>>>>>>> parent of 1238fb1... 修改cn-generator.rb，新增对翻译文件数量和进度的统计。
      # site.pages.each do |page|
      #   puts "#{page.url} => #{page.path}"
      # end
    end
  end
end