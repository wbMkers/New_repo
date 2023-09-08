CREATE OR REPLACE FUNCTION InsertDataFuncForDomainInfo() RETURNS TRIGGER AS $temp_table$  
    BEGIN  
		IF(NOT((LOWER(NEW.OFCABTYPE) = 'postgres') 
        and (LOWER(NEW.OFAPPSERVERTYPE) = 'jboss' or LOWER(NEW.OFAPPSERVERTYPE) = 'jbosseap' 
                or LOWER(NEW.OFAPPSERVERTYPE) = 'weblogic' or LOWER(NEW.OFAPPSERVERTYPE) = 'websphere' or LOWER(NEW.OFAPPSERVERTYPE) = 'jts')))
    	THEN
        	ROLLBACK;
    	END IF;
        RETURN NEW;  
    END;  
$temp_table$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER InsertDomainInfoData 
AFTER INSERT OR UPDATE ON IBPSUserDomainInfo  
FOR EACH ROW 
EXECUTE PROCEDURE InsertDataFuncForDomainInfo();