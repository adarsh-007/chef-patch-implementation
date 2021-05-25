module Readme
#using static path for testing, will use environment variable IHRDBMS for real scenario

#ihrdbms_env = env ['IHRDBMS]

def find_readme(pwd = '#{ihrdbms_env}/sapbundle')
	files = []	
    Find.find(pwd) do |path|
	#if path =~ /.*\.html$/
	if path =~ /README.htm*/
		files << path
		xmlfile[0]
	else 
		Chef::Application.fatal!("Unable to fetch file")
    	end
files[0]
end    
 

def get_readme_data
 g_readme_data = []
 File.open(find_readme).each do |f|
	f.chomp!				
	g_readme_data << f 
 end
 
end

Chef::Recipe.send(:include, Readme)