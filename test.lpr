library test;

{$mode objfpc}{$H+}

{$macro on}
{$define callconv:=
    {$IFDEF WINDOWS}{$IFDEF CPU32}cdecl;{$ELSE}{$ENDIF}{$ENDIF}
    {$IFDEF LINUX}{$IFDEF CPU32}cdecl;{$ELSE}{$ENDIF}{$ENDIF}
}

uses
  interfaces, classes, sysutils, math, lazmouseandkeyinput, Client;

var
  OldMemoryManager: TMemoryManager;
  memisset: Boolean = False;

type
  T3DIntegerArray = array of array of array of integer;

procedure TestWriteLn(s: String; Client: TClient); callconv
begin
  Client.WriteLn(s);
end;

function GetPluginABIVersion: Integer; callconv export;
begin
  Result := 2;
end;

procedure SetPluginMemManager(MemMgr : TMemoryManager); callconv export;
begin
  if memisset then
    exit;
  GetMemoryManager(OldMemoryManager);
  SetMemoryManager(MemMgr);
  memisset := true;
end;

procedure OnDetach; callconv export;
begin
  SetMemoryManager(OldMemoryManager);
end;

function GetTypeCount(): Integer; callconv export;
begin
  Result := 0;
end;

function GetTypeInfo(x: Integer; var sType, sTypeDef: PChar): integer; callconv export;
begin
  Result := -1;
end;

function GetFunctionCount(): Integer; callconv export;
begin
  Result := 1;
end;

function GetFunctionInfo(x: Integer; var ProcAddr: Pointer; var ProcDef: PChar): Integer; callconv export;
begin
  case x of
    0:
      begin
        ProcAddr := @TestWriteLn;
        StrPCopy(ProcDef, 'procedure TestWriteLn(s: String; Client: TClient = Client);');
      end;

    else
      x := -1;
  end;

  Result := x;
end;

exports GetPluginABIVersion;
exports SetPluginMemManager;
exports GetTypeCount;
exports GetTypeInfo;
exports GetFunctionCount;
exports GetFunctionInfo;
exports OnDetach;

begin
end.
