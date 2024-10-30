create or replace package clientes as
procedure lista;
procedure lista(pi_name customer.name%type);
procedure lista(pi_id customer.customer_id%type);
procedure ordenes( pi_min number);
end;


create or replace package body clientes is

type tr_cli is record (
    name customer.name%type,
    id customer.customer_id%type,
    phone_number customer.PHONE_NUMBER%type,
    orders number
);


type tt_cli is table of tr_cli index by binary_integer; 
t_cli tt_cli;


function valida_cli (pi_name customer.name%type) 
return number
is
v_index number;
begin
    v_index := 0;
    for i in 1..t_cli.count loop
        if upper(t_cli(i).name) = upper(pi_name) then
            v_index := i;
        end if;
    end loop;

    if v_index = 0 then
        raise_application_error(-20001, 'No existe el cliente indicado');
    end if;

    return v_index;

end;


function valida_cli (pi_id customer.customer_id%type) 
return number
is
v_index number;
begin
    v_index := 0;
    for i in 1..t_cli.count loop
        if t_cli(i).id = pi_id then
            v_index := i;
        end if;
    end loop;

    if v_index = 0 then
        raise_application_error(-20001, 'No existe el cliente indicado');
    end if;

    return v_index;

end;

procedure show (i number) as
begin
     dbms_output.put_line('Id: '|| t_cli(i).id ||', Nombre: '|| t_cli(i).name || ', Numero de telefono: ' || t_cli(i).phone_number || ', Cantidad de ordenes: ' || t_cli(i).orders);
end;

procedure lista
as
begin
    for i in 1..t_cli.count loop
        show(i);
    end loop;
end;

procedure lista(pi_name customer.name%type) as
v_index number;
begin
    v_index := valida_cli(pi_name);
    show(v_index);
end;

procedure lista(pi_id customer.customer_id%type)as
v_index number;
begin
    v_index := valida_cli(pi_id);
    show(v_index);
end;



procedure ordenes( pi_min number)as
begin
    for i in 1..t_cli.count loop
        if t_cli(i).orders > pi_min then
            dbms_output.put_line('Nombre: '|| t_cli(i).name || ', Numero de telefono: ' || t_cli(i).phone_number || ', Cantidad de ordenes: ' || t_cli(i).orders);
        end if;
    end loop;
end;

begin

    SELECT name, c.customer_id id,  phone_number, count(s.customer_id)
    BULK COLLECT INTO t_cli       
    FROM customer c inner join sales_order s on (c.customer_id = s.customer_id)
    group by name,  c.customer_id,  c.phone_number
    order by name;
    
end;



-- 