uses
   datetime,
   display,
   sockets,
   strings;

Const
   M_NUL = #0;   // human-readable information
   MSGHDR= #128; // 0x80 for non-data header

function SendCommand(Cmd:Char;Ss:String):String;
begin
   // Argus is doing: Result:=MsgHDR+Chr(Length(Ss)+2)+Cmd+Ss+#0; // PER LINE!
   // BinkD, MysticBBS, are doing:
   Result:=MsgHDR+Chr(Length(Ss)+1)+Cmd+Ss;
end;

var
   session:tdxsock;
   strlist:tstringlist;
   connlist:tstringlist;
   ts,ss:string;
   i:longint;
   intro:string;

begin
   connlist.init;
   connlist.loadfromfile('pollio.log');
   strlist.init;
   strlist.loadfromfile('polllist.txt');
   session.init;
   Writeln('There are ',StrList.getCount,' nodes.');
   for i:=0 to strlist.getcount-1 do begin
      ss:=strlist.getstrings(i);
      if pos(':',ss)<1 then begin
         write(FormatTimeStamp('mmm d hh:nn:ss',Timestamp)+' connecting to ',ss,' #',i);
         if session.connect(ss,24554) then begin
            Writeln('   Connected');
            connlist.add('BINKP: '+ss+' returned: ');
            intro:=SendCommand(M_NUL,"SYS RVA Fido Support")+
               SendCommand(M_NUL,"ZYZ G.E. Ozz Nixon Jr.")+
               SendCommand(M_NUL,"LOC Henrico, VA")+
               SendCommand(M_NUL,"PHN exchangebbs.com");
               SendCommand(M_NUL,"VER ExchangeBBS/0.1a2 binkp/1.0")+
               SendCommand(M_NUL,"NDL 115200,CM,XX,TCP,ICM,INA,IBN,BINKP")+
               SendCommand(M_NUL,"TRF 0 0")+ // if I have nothing to send, 0,0 is ok...
               SendCommand(M_NUL,"OPT NR TRF ND BRK")+
               SendCommand(M_NUL,"TIME "+FormatTimestamp("DDD, DD MMM YYYY HH:NN:SS GMT",Timestamp-(3600*5)));
            Session.Write(intro+#0);
            Yield(10); // plenty of TCP transaction time before something is readable:
            while session.countwaiting=0 do Yield(1);
            ts:=session.readStr(session.countwaiting,3);
            connlist.add(StringReplace(ts,#128,#9,[rfReplaceAll]));
            session.disconnect;
         end
         else Writeln();
      end;
      connlist.savetofile('pollio.log');
      if keypressed then break;
   end;
   session.free;
   strlist.free;
   connlist.savetofile('pollio.log');
   connlist.free;
end.
