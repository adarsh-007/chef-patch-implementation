module FixSet
#using static path for testing, will use environment variable IHRDBMS for real scenario

ihrdbms_env = env ['IHRDBMS']

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



 def fix_and_set
 	
 	readme_data = []
 	readme_data = get_readme_data 
	fix_control_start = readme_data.index('ALTER SYSTEM SET "_FIX_CONTROL"=')
	fix_control_end = readme_data.index("SCOPE=SPFILE;")


	File.new("fix_control_data.sql",'a+')
	f = File.open("fix_control_data.sql", 'a')
	while fix_control_start <= fix_control_end
  		f << readme_data[fix_control_start]
  		f << "\n"
		fix_control_start += 1
	end	
	f.close


  	set_scope = []

	set_event_start = readme_data.index('ALTER SYSTEM SET EVENT=')
	set_scope = readme_data.each_index.select{ |index| readme_data[index] =="SCOPE=SPFILE;" }
	set_event_end = set_scope[1]

 	File.new("set_event.sql",'a+')
 	f2 = File.open("set_event.sql", 'a')
 	while set_event_start <= set_event_end
	f2 << readme_data[set_event_start]
 	f2 << "\n"
	set_event_start += 1
 	end
 	f2.close
  
  end

	def fixset_files_created
		fix_and_set
		if Dir.exist?('fix_control_data.sql') && Dir.exist('set_event.sql')
			created = 'Yes'
		else
			created = 'No'	
		end
		created
	end

end

Chef::Recipe.send(:include, FixSet)