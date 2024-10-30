select *
from employee

select distinct name
from department

select * --first_name, last_name --comenta la linea
from employee
where department_id = 30
and salary > 1500


/*

comenta multiples lineas

*/

select first_name, last_name
from employee
where department_id = 30
order by first_name

select first_name, last_name, name, e.department_id
from employee e,
    department d
where e.department_id = d.department_id
order by first_name

select *
from product
where description like'_CE%'
-- _ 1 solo caracter..... % varios caracteres cualquiera

select *
from product
where product_id < 100900

select *
from employee
where department_id in (10,20)

select first_name, last_name, salary, sg.grade_id
from employee e,
    salary_grade sg
where e.salary between sg.lower_bound
                   and sg.upper_bound



select first_name || ' ' ||last_name nombre_completo -- ||concatena dos columnas, nombre_completo seria el alias de la nueva columna 
from employee


select *
from employee
where commission is not null

-- is null , is not null es recomendable... =null no porque despues si hay que operar cualquier cosa +- null = null!!!

---------------

nom y ap del jefe y colaboradores

select j.employee_id, j.first_name, j.last_name, e.employee_id, e.first_name, e.last_name
from employee e,
    employee j
where e.manager_id = j.employee_id (+)  -- el (+) agrega un jefe para mostrar el empleado o CEO que no tiene jefe
order by j.last_name, e.last_name

-- cuantos empleados tiene cada departamento
select d.department_id, name, count(e.employee_id) cantidad_empleados --count es una funcion de grupo es necesario group by
from employee e,
     department d
where e.department_id (+) = d.department_id --agregamos un empleado fictisio para poder ver los departamentos vacios!
group by d.department_id, name

--departamento con menos de 5 empleados

select d.department_id, name, count(e.employee_id) cantidad_empleados --count es una funcion de grupo es necesario group by
from employee e,
     department d
where e.department_id (+) = d.department_id --agregamos un empleado fictisio para poder ver los departamentos vacios!
group by d.department_id, name
having count(e.employee_id) < 3

--Funciones de fila simple-------------------------------

select sysdate --fecha de la DB
from dual   --tabla de motor con una sola fila

select user  
from dual 

select upper('Hola mundo')
from dual

select lower('Hola mundo')
from dual

select initcap('hola mundo')
from dual

select substr('Hola mundo',3,4) -- 3 donde inicia/ 4 cuantos toma
from dual

select trim('        Hola mundo        ') -- saca los espacios
from dual

select rpad('Hola mundo',20,'-') alias--agrega a la derecha del string n veces un caracter
from dual


select lpad('Hola mundo',20,'-') alias --agrega a la izquierda del string n veces un caracter
from dual

select round(155.888,2) alias --para redondear un numero, el segundo parametro hace que redonde en el segundo decimal
from dual

select trunc(155.888) alias --para cortar un numero o fecha!!!, el segundo parametro hace que redonde en el segundo decimal
from dual

-------------------------------------------------------------------------------------------------------------------------------
--castear o convertir a string, a number o a date 
select to_char(sysdate,'dd-mm-yyyy HH24:MI'), to_char(125.25)
from dual

select to_number('326,18')
from dual

select to_date('01/02/2003','DD/MM/YYYY')
from dual

select to_char(to_date('01/02/2003','DD/MM/YYYY'), 'dd-mm-yyyy hh24:mi')
from dual

--cuanto gana cada empleado  FUNCION NVL  (null value)

nvl(campo,valor)  --los dos parametros tienen que ser del mismo tipo


select first_name, last_name, salary, commission, salary+nvl(commission,0) total
from employee

select department_id, name, decode(location_id,122,'Mar de plata',
                                                124, 'Cordoba',
                                                location_id)
from department

------------------------ subconsultas

--nom ape salario todos los empleados que ganen por encima del promedio del salario DE SU DEPARTAMENTO
select first_name, last_name, salary
from employee e
where salary > (select avg(salary)
                from employee s
                where e.department_id = s.department_id) 
