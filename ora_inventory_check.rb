

module OraInventoryCheck
	def orainventorycheck
		stdout, stderr, status = Open3.capture3("$ORACLE_HOME/Opatch/opatch lsinventory")
		if status.include? '0'
			status = 'Success'
		else
			status = 'Failed'			 
		end 
			status
	end
end

Chef::Recipe.send(:include, BackupOracleHome )
