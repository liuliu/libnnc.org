#!/usr/bin/env ruby

require 'nokogiri'

exit unless ARGV.length == 2

def remove_ulinks doc
	# replace all ulink to be text
	doc.search('ulink').each do |ulink|
		ulink.replace Nokogiri::XML::Text.new(ulink.content, doc)
	end
end

require 'pathname'
require 'set'

input_path = Pathname.new(ARGV[0])
dirname = input_path.dirname.to_s
basename = input_path.basename('.xml').to_s
outdir = Pathname.new(ARGV[1])
exit unless outdir.directory?
outdir = outdir.to_s
candid_path = basename.gsub('__', '_')[6..-1]
until candid_path.length == 0 || candid_path[-1].match(/\d+/) do
	candid_path = candid_path.split('_')[0..-2].join('_')
end
outdir = outdir + '/' + candid_path

doc = Nokogiri::XML(open ARGV[0])
remove_ulinks doc

doc_group = doc.at './doxygen/compounddef'
doc_group.xpath('./innerpage').each do |innerpage|
	print 'Generating for ' + innerpage['refid'] + "\n"
	page = Nokogiri::XML(open(dirname + '/' + innerpage['refid'] + '.xml'))
	remove_ulinks page
	file = File.open(outdir + '/' + innerpage['refid'] + '.md', 'w+')
	page_doc = page.at './doxygen/compounddef'
	title = page_doc.at('./title').content.strip
	file << '# ' + title + "\n\n"
	paras = page_doc.xpath './detaileddescription/para'
	return structs if paras.length == 0
	desc = Array.new
	paras.each do |para|
		para = para.at('./text()').content
		desc << para if para.length > 0
	end
	file << desc.join("\n\n") << "\n"
	file.close
	if system('pandoc --wrap=none --from=markdown --to=rst --output ' + outdir + '/' + innerpage['refid'] + '.rst ' + outdir + '/' + innerpage['refid'] + '.md')
		system('rm -f ' + outdir + '/' + innerpage['refid'] + '.md')
	end
end
