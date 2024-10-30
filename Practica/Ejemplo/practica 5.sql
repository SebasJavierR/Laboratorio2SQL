--
/*
Crear un paquete EMP_PACK que contenga subprogramas públicos y privados:
Una función privada Valida_Job (job_id)  para validar si un cargo existe o no.
Una función privada Valida_Jefe (id) para validar si el id corresponde a un jefe existente. (Verificar que existe en la columna manager_id de la tabla Employee).
Un procedimiento público: Alta_Emp  que recibe como parámetros el código de empleado, nombre y apellido, cargo (job_id), y código de su jefe (manager_id).
a. Este procedimiento debe usar las funciones Valida_Job y Valida_Jefe.
b. Las columnas Middle_initial  y Commission por ahora dejarlas en nulls
c. En la columna Hire_date poner la fecha del día si no viene la fecha de ingreso por parámetro (Usar la opción Default en el parámetro)
d. El departamento en el que inicialmente se incorpora un empleado es el mismo en el que está su jefe
e. El salario del empleado inicialmente debe ser igual al salario mínimo de ese cargo y departamento.

*/
create or replace package EMP_PACK as

    function Valida_Job(pi_job job.job_id%TYPE) return boolean;
    function Valida_Jefe(pi_employee employee.employee_id%TYPE) return boolean;
    procedure Alta_Emp (pi_employee employee.employee_id%TYPE,
                    pi_employee_name employee.first_name%TYPE, 
                    pi_employee_last_name employee.LAST_NAME%TYPE,
                    pi_job_id employee.job_id%TYPE,
                    pi_manager_id employee.manager_id%TYPE,
                    pi_hire_date DATE DEFAULT sysdate);

    procedure Alta_Emp (pi_employee employee.employee_id%TYPE,
                    pi_employee_name employee.first_name%TYPE, 
                    pi_employee_last_name employee.LAST_NAME%TYPE,
                    pi_job_name job.function%TYPE,
                    pi_manager_id employee.manager_id%TYPE,
                    pi_hire_date DATE DEFAULT sysdate);

    function Valida_job(pi_job_name job.FUNCTION%TYPE) return job.job_id%type;
    


end;

    
 

create or replace package body EMP_PACK is

    function Valida_Job(pi_job job.job_id%TYPE) 
    return boolean is
    v_existe boolean := false;
    v_count number(5);
    begin 
        select count(job_id)
        into v_count
        from job j
        where j.job_id=pi_job;

        
        if v_count > 0 then
            v_existe:=true;
        end if;

        return v_existe;

        exception
            when no_data_found then
                raise_application_error(-20001,'Trabajo No Existente ');
            when others then
                raise_application_error(-20003,'error inesperado '||sqlerrm);
         

    end Valida_Job;

    function Valida_Jefe(pi_employee employee.employee_id%TYPE)
    return boolean is
    v_existe boolean := false;
    v_count number(5);
    begin 
        select count(manager_id)
        into v_count
        from employee e
        where e.MANAGER_ID=pi_employee;

        if v_count > 0 then
            v_existe:=true;
        end if;


        return v_existe;

        exception
            when no_data_found then
                raise_application_error(-20001,'Jefe No Existente ');
            when others then
                raise_application_error(-20003,'error inesperado '||sqlerrm);

    end Valida_Jefe;


    procedure Alta_Emp (pi_employee employee.employee_id%TYPE,
                        pi_employee_name employee.first_name%TYPE, 
                        pi_employee_last_name employee.LAST_NAME%TYPE,
                        pi_job_id employee.job_id%TYPE,
                        pi_manager_id employee.manager_id%TYPE,
                        pi_hire_date DATE DEFAULT sysdate)
    is
    
    l_max_employee_id employee.employee_id%type;
    v_manager_department employee.department_id%type;
    v_min_salary employee.salary%type;
    e_no_existe_manager  exception;
    pragma exception_init(e_no_existe_manager,-2291);      

    begin



        select nvl(max(employee_id),0)
        into l_max_employee_id
        from employee;

        select department_id
        into v_manager_department
        from employee
        where employee_id=pi_manager_id;

        select min(salary)
        into v_min_salary
        from employee
        where department_id=v_manager_department;



    

        insert into employee (EMPLOYEE_ID,LAST_NAME,FIRST_NAME,JOB_ID,MANAGER_ID,HIRE_DATE,department_id,salary)
            values (l_max_employee_id+1,pi_employee_last_name,pi_employee_name,pi_job_id,pi_manager_id,pi_hire_date,v_manager_department,v_min_salary);
        

        EXCEPTION
        WHEN no_data_found then
              raise_application_error(-20001,'Manager No Existente ');
        when e_no_existe_manager then 
              dbms_output.put_line('No existe el manager indicado.');
        when others then
            raise_application_error(-20003,'error inesperado '||sqlerrm);




    end Alta_Emp;

    --sobrecarga
    procedure Alta_Emp (pi_employee employee.employee_id%TYPE,
                    pi_employee_name employee.first_name%TYPE, 
                    pi_employee_last_name employee.LAST_NAME%TYPE,
                    pi_job_name job.function%TYPE,
                    pi_manager_id employee.manager_id%TYPE,
                    pi_hire_date DATE DEFAULT sysdate)
    is
    l_max_employee_id employee.employee_id%type;
    v_manager_department employee.department_id%type;
    v_min_salary employee.salary%type;
    e_no_existe_manager  exception;
    pragma exception_init(e_no_existe_manager,-2291);      

    begin



        select nvl(max(employee_id),0)
        into l_max_employee_id
        from employee;

        select department_id
        into v_manager_department
        from employee
        where employee_id=pi_manager_id;

        select min(salary)
        into v_min_salary
        from employee
        where department_id=v_manager_department;



    

        insert into employee (EMPLOYEE_ID,LAST_NAME,FIRST_NAME,JOB_ID,MANAGER_ID,HIRE_DATE,department_id,salary)
            values (l_max_employee_id+1,pi_employee_last_name,pi_employee_name,Valida_job(pi_job_name),pi_manager_id,pi_hire_date,v_manager_department,v_min_salary);
        

        EXCEPTION
        WHEN no_data_found then
              raise_application_error(-20001,'Manager No Existente ');
        when e_no_existe_manager then 
              dbms_output.put_line('No existe el manager indicado.');
        when others then
            raise_application_error(-20003,'error inesperado '||sqlerrm);



    end Alta_Emp;

    function Valida_job(pi_job_name job.FUNCTION%TYPE) 
        return job.job_id%type
    is 
    v_job_id job.job_id%type;

    begin
    
    select job_id
    into v_job_id
    from job
    where upper(pi_job_name)=upper(function);

    return v_job_id;
    


    exception
            when no_data_found then
                raise_application_error(-20001,'Cargo No Existente ');
            when others then
                raise_application_error(-20003,'error inesperado '||sqlerrm);

    end Valida_job;


end EMP_PACK;




declare
       

begin

    EMP_PACK.Alta_Emp(1,'tomasssss','stssssss',7,202);
    

end;

