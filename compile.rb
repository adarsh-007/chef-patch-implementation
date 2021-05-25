require 'open3'

#using static path for testing, will use environment variable ORACLE_HOME for real scenario

Dir.chdir("/oracle/EH7/11202/sapbundle")
#puts Dir.pwd

stdout1, stderr1, status1 = Open3.capture3("unzip /oracle/EH7/11202/sapbundle SAP*.zip")

version_in_sbp = get_version
oracle_version = sampada_code_function


if !version_in_sbp =  oracle _version 
	 Chef::Application.fatal!("Oracle version not matched with version in SAP bundle Patch")
else	

oracle_home_backup = backup_orcl_home
		if oracle_home_backup = 'Success'
			Chef::Log.info("Backup of Oracle home taken successfully")
		else
			Chef::Application.fatal!("Backup of Oracle Home failed")
		end

inventory_check = orainventorycheck
		if inventory_check = 'Success'
			Chef::Log.info("Backup of Oracle home taken successfully")
		else
			Chef::Application.fatal!("Backup of Oracle Home failed")
		end
		OraInventoryCheck
	
#will use ENV IHRDBMS in case of real scenario
# oracle_home_env = env ['IHRDBMS']

test_patch = []
test_patch << "mv /oracle/EH7/11202/MOPatch /oracle/EH7/11202/MOPatch-pre"
test_patch << "mv SAP*/SBP*/MOPatch /oracle/EH7/11202/MOPatch"
test_patch << "mv /oracle/EH7/11202/OPatch /oracle/EH7/11202/OPatch-pre"
test_patch << "mv SAP*/SBP*/OPatch /oracle/EH7/11202/OPatch"

a=0
 while a<=3
        stdout2, stderr2, status2 = Open3.capture3(test_patch[a])
        if status2.include? '0' 
        a += 1 
	else
		Chef::Application.fatal!("Command executed unsuccessfuly")
		puts stderr2 , a
        	# puts stderr , a
        	# puts status , a

	end
end
	
readme_data = []
readme_data = get_readme_data

install_patch_command = readme_data.index{|s| s.include?("env ORACLE_HOME=$IHRDBMS $IHRDBMS/MOPatch/mopatch.sh -v -s")}
	
	stdout3, stderr3, status3 = Open3.capture3(install_patch_command)
		if stdout3.include? 'patches successfully'
			Chef::Log.info("Patching completed successfully")
		else
			Chef::Application.fatal!("Patching Failed")
		end


cat_sbp_command = copy_catsbp

stdout4, stderr4, status4 = Open3.capture3(cat_sbp_command)
		if stdout4.include? ':  COMPLETE'
			Chef::Log.info("catsbp completed successfully")
		else
			Chef::Application.fatal!("catsbp failed")
		end	

confirm_created_files = fixset_files_created
		if confirm_created_files = 'Yes'
			Chef::Log.info("Files created succesfully for fix control and patch set")
		else
			Chef::Application.fatal!("Files not copied fix set and event")
		end	

stdout5 ,stderr5, status = Open3.capture3("sqlplus / as sysdba @catsbp.sql ")
stdout5 ,stderr5, status = Open3.capture3("sqlplus / as sysdba @fix_control_data.sql ")
stdout5 ,stderr5, status = Open3.capture3("sqlplus / as sysdba @set_event.sql ")

########################### Commands for bash
#!/bin/bash
# sqlplus / as sysdba <<EOF
# EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE);
# exit
# EOF
##########################

#echo 'EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE);' | sqlplus / as sysdba






	