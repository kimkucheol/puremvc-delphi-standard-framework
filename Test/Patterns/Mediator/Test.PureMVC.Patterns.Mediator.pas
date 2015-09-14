unit Test.PureMVC.Patterns.Mediator;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  System.Generics.Collections,
  TestFramework,
  PureMVC.Interfaces.INotification,
  PureMVC.Interfaces.IMediator,
  PureMVC.Patterns.Notification,
  PureMVC.Patterns.Mediator;

type

  TestTMediator = class(TTestCase)
  private
  public
  published
    procedure TestNameAccessor;
    procedure TestViewAccessor;
    procedure TestNotificationBase;
    procedure TestNotificationBaseMulti;
    procedure TestNotificationDerived;
    procedure TestNotificationDerivedMulti;
  end;

implementation

type
  TBaseMediator = class(TMediator)
  strict private
    FBaseCalls: Integer;
  public
    property BaseCalls: Integer read FBaseCalls;
    [PureMVCNotify('CallTest')]
    procedure OnBaseCallTest(Note: INotification);
  end;

  TDerivedMediator = class(TBaseMediator)
  strict private
    FDerivedCalls: Integer;
  public
    property DerivedCalls: Integer read FDerivedCalls;
    [PureMVCNotify('CallTest')]
    procedure OnDerivedCallTest(Note: INotification);
  end;

  TBaseMediatorMulti = class(TMediator)
  strict private
    FBaseCallsA: Integer;
    FBaseCallsB: Integer;
  private
    FBaseCalls: Integer;
  public
    property BaseCallsA: Integer read FBaseCallsA;
    property BaseCallsB: Integer read FBaseCallsB;
    [PureMVCNotify('CallTest')]
    procedure OnBaseCallTestA(Note: INotification);
    [PureMVCNotify('CallTest')]
    procedure OnBaseCallTestB(Note: INotification);
  end;

  TDerivedMediatorMulti = class(TBaseMediatorMulti)
  strict private
    FDerivedCallsA: Integer;
    FDerivedCallsB: Integer;
  private
    FBaseCalls: Integer;
  public
    property DerivedCallsA: Integer read FDerivedCallsA;
    property DerivedCallsB: Integer read FDerivedCallsB;
    [PureMVCNotify('CallTest')]
    procedure OnDerivedCallTestA(Note: INotification);
    [PureMVCNotify('CallTest')]
    procedure OnDerivedCallTestB(Note: INotification);
  end;


{ TSampleBaseMediator }

procedure TBaseMediator.OnBaseCallTest(Note: INotification);
begin
  Inc(FBaseCalls);
end;

{ TDerivedMediator }

procedure TDerivedMediator.OnDerivedCallTest(Note: INotification);
begin
  Inc(FDerivedCalls);
end;

{ TBaseMediatorMulti }

procedure TBaseMediatorMulti.OnBaseCallTestA(Note: INotification);
begin
  Inc(FBaseCallsA);
end;

procedure TBaseMediatorMulti.OnBaseCallTestB(Note: INotification);
begin
  Inc(FBaseCallsB);
end;

{ TDerivedMediatorMulti }

procedure TDerivedMediatorMulti.OnDerivedCallTestA(Note: INotification);
begin
  Inc(FDerivedCallsA);
end;

procedure TDerivedMediatorMulti.OnDerivedCallTestB(Note: INotification);
begin
  Inc(FDerivedCallsB);
end;

{ TestTMediator }

procedure TestTMediator.TestNameAccessor;
var
  Mediator: IMediator;
begin
  Mediator := TMediator.Create('TestMediator');
  CheckEquals('TestMediator', Mediator.MediatorName);
end;

procedure TestTMediator.TestNotificationBase;
var
  Mediator: TBaseMediator;
  DummyNote: INotification;
begin
  DummyNote := TNotification.Create('CallTest');
  Mediator := TBaseMediator.Create('TestMediator');
  Mediator.HandleNotification(DummyNote);
  try
    CheckEquals(1, Mediator.BaseCalls);
  finally
    Mediator.Free;
  end;
end;

procedure TestTMediator.TestNotificationBaseMulti;
var
  Mediator: TBaseMediatorMulti;
  DummyNote: INotification;
begin
  DummyNote := TNotification.Create('CallTest');
  Mediator := TBaseMediatorMulti.Create('TestMediator');
  try
    Mediator.HandleNotification(DummyNote);
    CheckEquals(0, Mediator.BaseCallsA, 'BaseCallsA');
    CheckEquals(1, Mediator.BaseCallsB, 'BaseCallsB');
  finally
    Mediator.Free;
  end;
end;

procedure TestTMediator.TestNotificationDerived;
var
  Mediator: TDerivedMediator;
  DummyNote: INotification;
begin
  DummyNote := TNotification.Create('CallTest');
  Mediator := TDerivedMediator.Create('TestMediator');
  Mediator.HandleNotification(DummyNote);
  try
    CheckEquals(0, Mediator.BaseCalls, 'BaseCalls');
    CheckEquals(1, Mediator.DerivedCalls, 'DerivedCalls');
  finally
    Mediator.Free;
  end;
end;

procedure TestTMediator.TestNotificationDerivedMulti;
var
  Mediator: TDerivedMediatorMulti;
  DummyNote: INotification;
begin
  DummyNote := TNotification.Create('CallTest');
  Mediator := TDerivedMediatorMulti.Create('TestMediator');
  Mediator.HandleNotification(DummyNote);
  try
    CheckEquals(0, Mediator.BaseCallsA, 'BaseCallsA');
    CheckEquals(0, Mediator.BaseCallsB, 'BaseCallsB');
    CheckEquals(0, Mediator.DerivedCallsA, 'DerivedCallsA');
    CheckEquals(1, Mediator.DerivedCallsB, 'DerivedCallsB');
  finally
    Mediator.Free;
  end;
end;

procedure TestTMediator.TestViewAccessor;
var
  View: TObject;
  Mediator: IMediator;
begin
  View := TObject.Create;
  Mediator := TMediator.Create('TestMediator', View);
  CheckSame(View, Mediator.ViewComponent);
  View.Free;
end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTMediator.Suite);

end.
