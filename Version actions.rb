module VersionSBP
#using static path for testing, will use environment variable IHRDBMS for real scenario

#ihrdbms_env = env ['IHRDBMS]

def find_xml(pwd = '#{ihrdbms_env}/sapbundle')  
  xmlfile = []
   Find.find(pwd) do |path|
   if path.include? 'actions.xml'
      xmlfile << path
     Chef::Log.info("Path of xml file copied successfully")
   else
    Chef::Application.fatal!("Unable to fetch file")
	end
xmlfile[0]
end          

def get_version
 xmldata = []
	File.open(find_xml).each do |lines| 
        xmldata << lines
	version_line = xmldata[1]
	get_vers= version_line.scan(/\d.+\d/)
	end 
end

Chef::Recipe.send(:include, VersionSBP)