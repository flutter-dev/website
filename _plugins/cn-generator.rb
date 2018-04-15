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
      site.pages.each do |page|
        newPath = "#{site.source}/#{PREFIX}/#{page.path}"
        isFileExist = File.exist?(newPath)
        if isFileExist
          site.pages.delete(page)
        end
      end
      # site.pages.each do |page|
      #   puts "#{page.url} => #{page.path}"
      # end
    end
  end
end