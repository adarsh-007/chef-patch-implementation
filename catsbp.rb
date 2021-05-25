module Catsbp

ihrdbms_env = env ['IHRDBMS']


def find_catsbp (pwd = '#{ihrdbms_env}/sapbundle')
  catsbp = ''  
   Find.find(pwd) do |path|
if path =~ /catsbp/
    catsbp << path
    Chef::Log.info("Path of catsbp file copied successfully")
  end
else 
     Chef::Application.fatal!("Unable to fetch file") 
end   
catsbp
end  

def copy_catsbp	
catsbp_path = find_catsbp 
	catsbp_command = "cp #{catsbp_path} #{ihrdbms_env}/sapbundle"
	catsbp_command 
end

end

Chef::Recipe.send(:include, catsbp)