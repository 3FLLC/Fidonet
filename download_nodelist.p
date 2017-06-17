Program Nodelist.Downloader.v1170617;

uses environment, strings, datetime, sockets;

var
   fn,ws,buffer:String;
   Client:TDXSock;
   _FileSize:LongWord;
   Header:Boolean;

function n2(I:Int64):String;
Begin
   Result:=IntToStr(I);
   If I<10 then Result:='0'+Result
   Else If I>99 then Result:=Copy(Result,Length(Result)-1,2);
End;

function n3(I:Int64):String;
Begin
   Result:=IntToStr(I);
   If I<10 then Result:='0'+Result;
   If I<100 then Result:='0'+Result
   Else If I>999 then Result:=Copy(Result,Length(Result)-2,3);
End;

Begin
   Writeln('ExchangeBBS Fidonet Nodelist Downloader v0.1');
   Case DayOfWeek(Timestamp) of
      1:fn:='nodelist.z'+n2(DayOfYear(Timestamp)-2);
      2:fn:='nodelist.z'+n2(DayOfYear(Timestamp)-3);
      3:fn:='nodelist.z'+n2(DayOfYear(Timestamp)-4);
      4:fn:='nodelist.z'+n2(DayOfYear(Timestamp)-5);
      5:fn:='nodelist.z'+n2(DayOfYear(Timestamp)-6);
      6:fn:='nodelist.z'+n2(DayOfYear(Timestamp));
      7:fn:='nodelist.z'+n2(DayOfYear(Timestamp)-1);
   End;
   Client.Init;
   If Client.ConnectTo('www.filegate.net',80) then begin
      Header:=True;
      Buffer:='';
      Client.Writeln('GET /nodelist/'+fn+' HTTP/1.0');
      Client.Writeln('Host: www.filegate.net');
      Client.Writeln('User-agent: exchangebbs.com');
      Client.Writeln('');
      While Client.Connected do begin
         If Client.Readable then begin
            If Client.CountWaiting=0 then break;
            if Header then begin
               Ws:=Client.Readln(500);
               Writeln(Ws);
               If (Ws='') then Header:=False
               else If Lowercase(Fetch(Ws,':'))='content-length' then begin
                  _FileSize:=StrToIntDef(Trim(Ws),0);
               End;
            End
            Else Begin
               Buffer+=Client.ReadStr(Client.CountWaiting,500);
               If _FileSize>=Length(Buffer) then begin
                  SaveToFile(Buffer,Fn);
                  Client.Disconnect;
                  Writeln('Saved ',fn,' ',_FileSize,' bytes.');
                  ExecuteEx('/usr/bin/unzip',['-o',fn]);
                  Case DayOfWeek(Timestamp) of
                     1:fn:='nodelist.'+n3(DayOfYear(Timestamp)-2);
                     2:fn:='nodelist.'+n3(DayOfYear(Timestamp)-3);
                     3:fn:='nodelist.'+n3(DayOfYear(Timestamp)-4);
                     4:fn:='nodelist.'+n3(DayOfYear(Timestamp)-5);
                     5:fn:='nodelist.'+n3(DayOfYear(Timestamp)-6);
                     6:fn:='nodelist.'+n3(DayOfYear(Timestamp));
                     7:fn:='nodelist.'+n3(DayOfYear(Timestamp)-1);
                  End;
                  Writeln('Calling nodelist compiler...');
                  // call goes here //
               End;
            End;
         End
         Else Yield(1);
      End;
      If Client.CountWaiting>0 then Writeln('Waiting ',Client.CountWaiting);
   End;
   Client.Free;
End;
