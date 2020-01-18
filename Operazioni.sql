use softwarehouse;

/*INSERIMENTO*/
/*1.Inserire un Cliente Privato.*/

insert into cliente (CodiceC,Indirizzo,Email) values(?,?);
insert into privato(CF,Nome,Cognome,Data_nascita,Cliente_CodiceC) values(?,?);
insert into telefono_fax(Numero,Tipo,Cliente_CodiceC) values(?,?,?);

/*2.Inserire un Cliente Azienda*/

insert into cliente (CodiceC,Indirizzo,Email) values(?,?);
insert into azienda(Partita_iva,Ragione_sociale,Cliente_CodiceC) values(?,?,?);
insert into telefono_fax(Numero,Tipo,Cliente_CodiceC) values(?,?,?);

/*3.Inserire un Software con relativo Sistema Operativo.*/

insert into software(CodiceS,Nome,Tipo,Prezzo,Caratteristica,Licenza,Versione) values (?,?,?,?,?,?,?);
insert into sistema_operativo (Sistema,Software_CodiceS) values(?,?);

/*4.Inserire un Corso Formativo.*/

insert into corso_formativo(CodiceCF,Descrizione,Durata_in_ore,Data_inizio,Numero_esami) values(?,?,?,?,?,?,?);

/*5.Inserire un Problema segnalato da un determinato Cliente per un Software.*/

insert problema(Descrizione,Numero,Risolto,Software_CodiceS,Cliente_CodiceC,Operatore_CodiceO) values (?,?,?,?,?,?);

/*6.Inserire un Attestato per uno specifico Corso Formativo ad uno specifico cliente*/

insert into attestato(Data_rilascio,Corso_Formativo_CodiceCF,Cliente_CodiceC) values(?,?,?);

/*7.Inserire un Operatore.*/

insert into operatore(CodiceO,Nome,Cognome,Data_nascita,CF,Ruolo) values(?,?,?,?,?,?);

/*8.Far seguire un cliente un Corso Formativo.*/

insert into segue (Numero_esami_dati,Cliente_CodiceC,Corso_Formativo_CodiceCF)  values(0,?,?);

/*9.Far acquistare un Software a un Cliente*/

insert into acquista(Software_CodiceS,Cliente_CodiceC) values(?,?);

/*10.Inserire un nuovo Telefono/Fax per un Cliente.*/

insert into telefono_fax(Numero,Tipo,Cliente_CodiceC) values(?,?,?);

/*11.Rendere compatibile un Software per un determinato Sistema Operativo. */

insert into sistema_operativo(Sistema,Software_CodiceS) values (?,?);

/*VISUALIZZAZIONE*/

/*12.Stampare il numero di esami conseguiti da un Privato per un Corso Formativo.*/

select corso_formativo.CodiceCF,corso_formativo.Descrizione,corso_formativo.Numero_esami,segue.numero_esami_dati 
from privato inner join segue on privato.Cliente_CodiceC=segue.Cliente_CodiceC
inner join corso_formativo on segue.Corso_Formativo_CodiceCF=corso_formativo.CodiceCF
where privato.Cliente_CodiceC= 4;

/*13.Visualizzare il numero di esami mancanti per ogni Cliente inerenti ad un Corso Formativo.*/

select privato.CF, privato.Nome, privato.Cognome, privato.Data_nascita, azienda.Partita_iva, azienda.Ragione_sociale, cliente.Indirizzo, cliente.Email, corso_formativo.numero_esami-segue.Numero_esami_dati as Esami_mancanti
from segue inner join cliente on segue.Cliente_CodiceC=cliente.CodiceC left join privato on cliente.CodiceC=privato.Cliente_CodiceC left join azienda on cliente.CodiceC=azienda.Cliente_CodiceC inner join corso_formativo on corso_formativo.CodiceCF=segue.Corso_Formativo_CodiceCF
where corso_formativo.CodiceCF=2;

/*14.Mostrare quali Azienda hanno conseguito almeno n esami.*/

select distinct (cliente.CodiceC), azienda.Partita_iva, azienda.Ragione_sociale, cliente.Indirizzo, cliente.Email, telefono_fax.Numero, telefono_fax.Tipo 
from azienda inner join cliente on azienda.Cliente_CodiceC=cliente.CodiceC
inner join telefono_fax on cliente.CodiceC=telefono_fax.Cliente_CodiceC
inner join segue on segue.Cliente_codiceC=cliente.CodiceC
where segue.numero_esami_dati>2 and segue.Corso_Formativo_CodiceCF=2 and (telefono_fax.Tipo='T' || telefono_fax.Tipo='E');

/*15.Visualizzare un Operatore che ha preso in carico un determinato Problema. */

select operatore.*
from operatore inner join problema on operatore.CodiceO=problema.Operatore_CodiceO
where problema.Software_CodiceS=6 AND problema.Numero=1;

/*16.Stampare tutti i Sistemi Operativi compatibili per uno specifico Software.*/

select sistema_operativo.Sistema
from  sistema_operativo
where sistema_operativo.Software_CodiceS=1;

/*17.Mostrare tutti i Clienti che hanno speso un totale di p Euro.*/

select cliente.*, privato.CF, privato.Nome, privato.Cognome, azienda.Ragione_sociale, azienda.Partita_iva
from cliente left join privato on privato.Cliente_CodiceC=cliente.CodiceC left join azienda on azienda.Cliente_CodiceC=cliente.CodiceC inner join acquista on cliente.CodiceC=acquista.Cliente_CodiceC
inner join software on software.CodiceS=acquista.Software_CodiceS
group by cliente.CodiceC
having sum(prezzo)>100;

/*18.Visualizzare l'elenco di tutti gli Attestati conseguiti da un Cliente.*/

select privato.CF, privato.Nome, privato.Cognome, azienda.Ragione_sociale, azienda.Partita_iva, cliente.Indirizzo, cliente.Email, attestato.Corso_Formativo_CodiceCF,corso_formativo.Descrizione,attestato.data_rilascio
from cliente inner join attestato on cliente.CodiceC=attestato.Cliente_CodiceC left join privato on privato.Cliente_CodiceC=cliente.CodiceC left join azienda on azienda.Cliente_CodiceC=cliente.CodiceC inner join corso_formativo on attestato.Corso_Formativo_CodiceCF=corso_formativo.CodiceCF
where attestato.Cliente_CodiceC=3;

/*19.Stampare tutte le Aziende alle quali potrebbero interessare dei Software in base agli acquisti, inserito un tipo di riferimento. */
select azienda.*

from software inner join acquista on software.CodiceS=acquista.Software_CodiceS
inner join cliente on cliente.CodiceC=acquista.Cliente_CodiceC
inner join azienda on azienda.Cliente_CodiceC=cliente.CodiceC
where software.tipo='Firmware';

/*20.Visualizzare i clienti che hanno conseguito un numero di esami pari a quelli previsti dal corso formativo*/
 
select  privato.CF, privato.Nome, privato.Cognome, azienda.Ragione_sociale, azienda.Partita_iva, cliente.CodiceC,cliente.Indirizzo,cliente.Email, corso_formativo.CodiceCF,corso_formativo.Descrizione
from cliente left join privato on privato.Cliente_CodiceC=cliente.CodiceC left join azienda on azienda.Cliente_CodiceC=cliente.CodiceC inner join segue on cliente.codiceC=segue.Cliente_CodiceC
join corso_formativo  on segue.Corso_Formativo_CodiceCF=corso_formativo.CodiceCF
where segue.Numero_esami_dati=corso_formativo.Numero_esami;

/*21.Visualizzare quale Software ha avuto piu Problemi*/

select software.*
from software
where software.CodiceS=(select software_CodiceS
			from problema
			where numero=(select max(numero)
				      from problema));

/*22.Visualizzare l'operatore che si prende carico di un Problema di un determinato Software.*/

select operatore.*
from operatore inner join problema on operatore.CodiceO=problema.Operatore_CodiceO
where problema.software_CodiceS=6 AND problema.numero=1;

/*23.Visualizzare i numeri di Telefono/Fax di un Cliente*/

select telefono_fax.numero, telefono_fax.tipo
from telefono_fax
where telefono_fax.Cliente_CodiceC=1;

/*24.Quanti Clienti hanno acquistato un Software.*/

select count(acquista.Cliente_CodiceC) as numClienti
from acquista 
where acquista.Software_CodiceS=6;

/*AGGIARNAMENTO*/

/*25.Aggiornare il numero di esami dati per un Cliente*/

update segue
set segue.numero_esami_dati=(select numero_esami_dati
			     where segue.Cliente_CodiceC=? and  segue.Corso_formativo_CodiceCF=?)+1
where segue.Cliente_CodiceC=? and segue.Corso_formativo_CodiceCF=?;

/*26.Aggiornare il prezzo di un dato Software.*/

update software
set software.Prezzo=?
where software.CodiceS=?;

/*27.Aggiornare il campo risolto di Problema.*/

update problema
set problema.Risolto=?
where problema.Software_CodiceS=? and problema.numero=?;