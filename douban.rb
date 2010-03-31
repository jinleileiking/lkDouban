require 'digest/md5'
require 'net/http'
require 'open-uri'
require 'iconv'
require 'ostruct'
require 'rexml/document'
require 'pp'
include REXML




def getBookCollection()
  url = 'http://api.douban.com/people/jinleileiking/collection?cat=book&status=read'
  Net::HTTP.version_1_2
  open(url)do|http|
    atom = http.read

    @table = []
    doc=REXML::Document.new(atom)
    
    tmp = 0
    doc.elements.each("//entry/db:subject/title") do |e|
      #      gbk = to_gbk(e.text)
      #      p gbk
#      Iconv.iconv("UTF-8//IGNORE","GB2312//IGNORE",e.text)
      @table[tmp] = {:title => e.text}
      tmp = tmp +1
    end

    tmp = 0
    doc.elements.each("//entry/db:subject/link") do |e|
      if e.attributes["rel"] == "alternate"
        @table[tmp] = @table[tmp].merge({:href => e.attributes["href"]})
        tmp = tmp +1
      end
    end
    return @table
  end
end

pp getBookCollection