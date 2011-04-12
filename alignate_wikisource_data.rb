#coding: utf-8
require_relative "lib/word_alignator"
require_relative "lib/weak_ocr"
require_relative "lib/ocr"
require_relative 'lib/ocrx_word'
require 'erb'
require 'paperclip'
path = "data"

for filename in ['Seite_Gottschalck_Sagen_und_Voksmaehrchen_der_Deutschen_194', 'Lied_aus_Schlaufaffenland', 'Gelobet_seystu_Jesu_Christ','Ein_erschoecklich_gschicht_Vom_Tewfel','Affentheater','Sant_kmernusl','Ueber_den_Gebrauch_des_englischen_Wortes_Sir','Seite_Die_Gartenlaube_242','Seite_Tagebuch_H_C_Lang_05','Seite_Tagebuch_H_C_Lang_08'] do
    @ground_truth = OCR.new(path + '/ocr/' + filename + '.txt')
    @weak_ocr = WeakOCR.new(path + '/wikiResult/' + filename + '.html')
    
    @width,@height = '1300px', "2500px"
    
    #@width,@height = Paperclip::Geometry.from_file(path + '/image' + filename + '.jpg')


    word_alignator = WordAlignator.new(@ground_truth.lines.flatten, @weak_ocr.lines.flatten)
    word_alignator.alignate


    @html = File.open( path + "/html_out/#{filename}_debug.html", "w+")
    @image_url = "../img/#{filename}.jpg"
    @alignated_words    = [word_alignator.alignated_line]
    @surplus_lines      =  { :ocr => [], :weak_ocr => []}
    @dropped_words  = {
    	ocr: word_alignator.dropped_ocr_words,
    	weak_ocr: word_alignator.dropped_weak_ocr_words
    	}
    
    @word_count_gt = @ground_truth.lines.flatten.length
    @word_count_weak_ocr=  @weak_ocr.lines.flatten.length
    @word_count_alignated =  @alignated_words.flatten.length
    
    @percent_alignated = 100.0 / @word_count_gt * @word_count_alignated

    @html << ERB.new( File.open('wikisource_alignated_image.erb' ){ |f| f.read } ).result( binding )	
end
