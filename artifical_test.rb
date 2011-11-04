#coding: utf-8
require_relative "word_alignator_no_lines"
require_relative "weak_ocr"
require_relative "ocr"
require_relative 'ocrx_word'
require 'erb'

id_and_page = 'bsb10373337_00010'
#'bsb10230377_00020' ## "bsb10373337_00010"

@ground_truth_test = OCR.new('../OCR/'+ id_and_page + '.txt_gt').lines.flatten
@weak_ocr_test = WeakOCR.new("../WeakOCR/"+  id_and_page +".html").lines.flatten


word_alignator = WordAlignator.new(@ground_truth_test, @weak_ocr_test)
word_alignator.alignate


@html = File.open("html_out/" + "no_lines" + id_and_page + "_gt_out.html", "w+")
@image_url = "../../Images/" + id_and_page + ".jpg"
@alignated_words    = [word_alignator.alignated_line]
@surplus_lines      =  { :ocr => [], :weak_ocr => []}
@dropped_words  = {
	ocr: word_alignator.dropped_ocr_words,
	weak_ocr: word_alignator.dropped_weak_ocr_words
	}

@html << ERB.new( File.open('alignated_image.erb' ){ |f| f.read } ).result( binding )