
# oracle_home_
# oracle_home_env = env ['ORACLE_HOME']

module BackupOracleHome
	def backup_orcl_home
		stdout, stderr, status = Open3.capture3("tar -hcvf $ORACLE_HOME$(date +%d-%b-%Y).tar $ORACLE_HOME")
		if status.include? '0'
			status = 'Success'
		else
			status = 'Failed'			 
		end 
			status
	end
end

Chef::Recipe.send(:include, BackupOracleHome )
