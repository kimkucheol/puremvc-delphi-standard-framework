unit PureMVC.Patterns.Facade;

interface

uses
  SysUtils, RTTI, Controls,
  PureMVC.Interfaces.IModel,
  PureMVC.Interfaces.IController,
  PureMVC.Interfaces.IProxy,
  PureMVC.Interfaces.IView,
  PureMVC.Interfaces.INotification,
  PureMVC.Interfaces.IMediator,
  PureMVC.Interfaces.IFacade;

type
  /// <summary>
  /// A base Singleton <c>IFacade</c> implementation
  /// </summary>
  /// <remarks>
  /// <para>In PureMVC, the <c>Facade</c> class assumes these responsibilities:</para>
  /// <list type="bullet">
  /// <item>Initializing the <c>Model</c>, <c>View</c> and <c>Controller</c> Singletons</item>
  /// <item>Providing all the methods defined by the <c>IModel, IView, &amp; IController</c> interfaces</item>
  /// <item>Providing the ability to override the specific <c>Model</c>, <c>View</c> and <c>Controller</c> Singletons created</item>
  /// <item>Providing a single point of contact to the application for registering <c>Commands</c> and notifying <c>Observers</c></item>
  /// </list>
  /// <example>
  /// <code>
  /// using PureMVC.Patterns;
  ///
  /// using com.me.myapp.model;
  /// using com.me.myapp.view;
  /// using com.me.myapp.controller;
  ///
  /// public class MyFacade : Facade
  /// {
  /// // Notification constants. The Facade is the ideal
  /// // location for these constants, since any part
  /// // of the application participating in PureMVC
  /// // Observer Notification will know the Facade.
  /// public static const string GO_COMMAND = "go";
  ///
  /// // we aren't allowed to initialize new instances from outside this class
  /// protected MyFacade() {}
  ///
  /// // we must specify the type of instance
  /// static MyFacade()
  /// {
  /// instance = new MyFacade();
  /// }
  ///
  /// // Override Singleton Factory method
  /// public new static MyFacade getInstance() {
  /// return instance as MyFacade;
  /// }
  ///
  /// // optional initialization hook for Facade
  /// public override void initializeFacade() {
  /// base.initializeFacade();
  /// // do any special subclass initialization here
  /// }
  ///
  /// // optional initialization hook for Controller
  /// public override void initializeController() {
  /// // call base to use the PureMVC Controller Singleton.
  /// base.initializeController();
  ///
  /// // Otherwise, if you're implmenting your own
  /// // IController, then instead do:
  /// // if ( controller != null ) return;
  /// // controller = MyAppController.getInstance();
  ///
  /// // do any special subclass initialization here
  /// // such as registering Commands
  /// registerCommand( GO_COMMAND, com.me.myapp.controller.GoCommand )
  /// }
  ///
  /// // optional initialization hook for Model
  /// public override void initializeModel() {
  /// // call base to use the PureMVC Model Singleton.
  /// base.initializeModel();
  ///
  /// // Otherwise, if you're implmenting your own
  /// // IModel, then instead do:
  /// // if ( model != null ) return;
  /// // model = MyAppModel.getInstance();
  ///
  /// // do any special subclass initialization here
  /// // such as creating and registering Model proxys
  /// // that don't require a facade reference at
  /// // construction time, such as fixed type lists
  /// // that never need to send Notifications.
  /// regsiterProxy( new USStateNamesProxy() );
  ///
  /// // CAREFUL: Can't reference Facade instance in constructor
  /// // of new Proxys from here, since this step is part of
  /// // Facade construction!  Usually, Proxys needing to send
  /// // notifications are registered elsewhere in the app
  /// // for this reason.
  /// }
  ///
  /// // optional initialization hook for View
  /// public override void initializeView() {
  /// // call base to use the PureMVC View Singleton.
  /// base.initializeView();
  ///
  /// // Otherwise, if you're implmenting your own
  /// // IView, then instead do:
  /// // if ( view != null ) return;
  /// // view = MyAppView.Instance;
  ///
  /// // do any special subclass initialization here
  /// // such as creating and registering Mediators
  /// // that do not need a Facade reference at construction
  /// // time.
  /// registerMediator( new LoginMediator() );
  ///
  /// // CAREFUL: Can't reference Facade instance in constructor
  /// // of new Mediators from here, since this is a step
  /// // in Facade construction! Usually, all Mediators need
  /// // receive notifications, and are registered elsewhere in
  /// // the app for this reason.
  /// }
  /// }
  /// </code>
  /// </example>
  /// </remarks>
  /// <see cref="PureMVC.Core.Model"/>
  /// <see cref="PureMVC.Core.View"/>
  /// <see cref="PureMVC.Core.Controller"/>
  /// <see cref="PureMVC.Patterns.Notification"/>
  /// <see cref="PureMVC.Patterns.Mediator"/>
  /// <see cref="PureMVC.Patterns.Proxy"/>
  /// <see cref="PureMVC.Patterns.SimpleCommand"/>
  /// <see cref="PureMVC.Patterns.MacroCommand"/>

  TFacadeClass = class of TFacade;
  TOnGetFacadeClassEvent = procedure(var FacadeClass: TFacadeClass) of object;

  TFacade = class(TInterfacedObject, IFacade)
  private
    class var FOnGetFacadeClass: TOnGetFacadeClassEvent;
  protected
    constructor Create;
    class property OnGetFacadeClass: TOnGetFacadeClassEvent
        read FOnGetFacadeClass write FOnGetFacadeClass;
  public
    destructor Destroy; override;

{$REGION 'Proxy'}
  public
    procedure RegisterProxy(Proxy: IProxy);
    function RetrieveProxy(ProxyName: string): IProxy;
    function RemoveProxy(ProxyName: string): IProxy;
    function HasProxy(ProxyName: string): Boolean;
{$ENDREGION}
{$REGION 'Command'}
  public
    procedure RegisterCommand(NotificationName: string; CommandClass: TClass);
    procedure RemoveCommand(NotificationName: string);
    function HasCommand(NotificationName: string): Boolean;
{$ENDREGION}
{$REGION 'Mediator'}
  public
    procedure RegisterMediator(Mediator: IMediator);
    function RetrieveMediator(MediatorName: string): IMediator;
    function RemoveMediator(MediatorName: string): IMediator; overload;
    function RemoveMediator(Mediator: IMediator): IMediator; overload;
    function HasMediator(MediatorName: string): Boolean;
{$ENDREGION}
{$REGION 'Observer'}
  public
    procedure NotifyObservers(Notification: INotification);
{$ENDREGION}
{$REGION 'INotifier Members'}
  public
    procedure SendNotification(NotificationName: string); overload;
    procedure SendNotification(NotificationName: string;
        Body: TValue); overload;
    procedure SendNotification(NotificationName: string; Body: TValue;
        Kind: TValue); overload;virtual;
{$ENDREGION}
{$REGION 'Accessors'}
  public
    /// <summary>
    /// Facade Singleton Factory method.  This method is thread safe.
    /// </summary>
    class function Instance: IFacade; static;
{$ENDREGION}
{$REGION 'Protected & Internal Methods'}
  protected
    /// <summary>
    /// Initialize the Singleton <c>Facade</c> instance
    /// </summary>
    /// <remarks>
    /// <para>Called automatically by the constructor. Override in your subclass to do any subclass specific initializations. Be sure to call <c>base.initializeFacade()</c>, though</para>
    /// </remarks>
    procedure InitializeFacade; virtual;
    /// <summary>
    /// Initialize the <c>Controller</c>
    /// </summary>
    /// <remarks>
    /// <para>Called by the <c>initializeFacade</c> method. Override this method in your subclass of <c>Facade</c> if one or both of the following are true:</para>
    /// <list type="bullet">
    /// <item>You wish to initialize a different <c>IController</c></item>
    /// <item>You have <c>Commands</c> to register with the <c>Controller</c> at startup</item>
    /// </list>
    /// <para>If you don't want to initialize a different <c>IController</c>, call <c>base.initializeController()</c> at the beginning of your method, then register <c>Command</c>s</para>
    /// </remarks>
    procedure InitializeController; virtual;
    /// <summary>
    /// Initialize the <c>Model</c>
    /// </summary>
    /// <remarks>
    /// <para>Called by the <c>initializeFacade</c> method. Override this method in your subclass of <c>Facade</c> if one or both of the following are true:</para>
    /// <list type="bullet">
    /// <item>You wish to initialize a different <c>IModel</c></item>
    /// <item>You have <c>Proxy</c>s to register with the Model that do not retrieve a reference to the Facade at construction time</item>
    /// </list>
    /// <para>If you don't want to initialize a different <c>IModel</c>, call <c>base.initializeModel()</c> at the beginning of your method, then register <c>Proxy</c>s</para>
    /// <para>Note: This method is <i>rarely</i> overridden; in practice you are more likely to use a <c>Command</c> to create and register <c>Proxy</c>s with the <c>Model</c>, since <c>Proxy</c>s with mutable data will likely need to send <c>INotification</c>s and thus will likely want to fetch a reference to the <c>Facade</c> during their construction</para>
    /// </remarks>
    procedure InitializeModel; virtual;
    /// <summary>
    /// Initialize the <c>View</c>
    /// </summary>
    /// <remarks>
    /// <para>Called by the <c>initializeFacade</c> method. Override this method in your subclass of <c>Facade</c> if one or both of the following are true:</para>
    /// <list type="bullet">
    /// <item>You wish to initialize a different <c>IView</c></item>
    /// <item>You have <c>Observers</c> to register with the <c>View</c></item>
    /// </list>
    /// <para>If you don't want to initialize a different <c>IView</c>, call <c>base.initializeView()</c> at the beginning of your method, then register <c>IMediator</c> instances</para>
    /// <para>Note: This method is <i>rarely</i> overridden; in practice you are more likely to use a <c>Command</c> to create and register <c>Mediator</c>s with the <c>View</c>, since <c>IMediator</c> instances will need to send <c>INotification</c>s and thus will likely want to fetch a reference to the <c>Facade</c> during their construction</para>
    /// </remarks>
    procedure InitializeView; virtual;

{$ENDREGION}

{$REGION 'Members'}
  protected
    FController: IController;
    FModel: IModel;
    FView: IView;
    class var FInstance: IFacade;
    class var FStaticSyncRoot: TObject;
{$ENDREGION}

  end;

implementation

uses
  Windows,
  SummerFW.Utils.RTL,
  PureMVC.Core.View,
  PureMVC.Core.Controller,
  PureMVC.Patterns.Notification;

constructor TFacade.Create;
begin
  inherited;
  InitializeFacade;
end;

procedure TFacade.InitializeFacade;
begin
  InitializeModel;
  InitializeController;
  InitializeView;
end;

procedure TFacade.InitializeModel;
begin

end;

procedure TFacade.InitializeController;
begin
  if (FController <> nil) then
    Exit;
  FController := TController.Instance;
end;

procedure TFacade.InitializeView;
begin
  if (FView <> nil) then
    Exit;
  FView := TView.Instance;
end;

class function TFacade.Instance: IFacade;
var
  FacadeClass: TFacadeClass;
begin
  if (FInstance = nil) then
    Sync.Lock(FStaticSyncRoot, procedure begin FacadeClass := nil;
        if Assigned(FOnGetFacadeClass) then FOnGetFacadeClass(FacadeClass);
        if FacadeClass = nil then FacadeClass := TFacade;
        if (FInstance = nil) then begin FInstance := FacadeClass.Create; end;

    end);

  Result := FInstance;
end;

{$REGION 'Proxy'}

function TFacade.RemoveProxy(ProxyName: string): IProxy;
begin
  Result := FModel.RemoveProxy(ProxyName);
end;

procedure TFacade.RegisterProxy(Proxy: IProxy);
begin
  FModel.RegisterProxy(Proxy);
end;

function TFacade.RetrieveProxy(ProxyName: string): IProxy;
begin
  Result := FModel.RetrieveProxy(ProxyName);
end;

function TFacade.HasProxy(ProxyName: string): Boolean;
begin
  Result := FModel.HasProxy(ProxyName);
end;

{$ENDREGION}
{$REGION 'Mediator'}

procedure TFacade.RegisterMediator(Mediator: IMediator);
begin
  FView.RegisterMediator(Mediator);
end;

function TFacade.RetrieveMediator(MediatorName: string): IMediator;
begin
  Result := FView.RetrieveMediator(MediatorName);
end;

function TFacade.RemoveMediator(MediatorName: string): IMediator;
begin
  Result := FView.RemoveMediator(MediatorName);
end;

function TFacade.RemoveMediator(Mediator: IMediator): IMediator;
begin
  Result := FView.RemoveMediator(Mediator);
end;

function TFacade.HasMediator(MediatorName: string): Boolean;
begin
  Result := FView.HasMediator(MediatorName);
end;
{$ENDREGION}
{$REGION 'Command'}

procedure TFacade.RegisterCommand(NotificationName: string;
    CommandClass: TClass);
begin
  FController.RegisterCommand(NotificationName, CommandClass);
end;

destructor TFacade.Destroy;
begin
  FController := nil;
  FModel := nil;
  FView := nil;
  inherited;
end;

function TFacade.HasCommand(NotificationName: string): Boolean;
begin
  Result := FController.HasCommand(NotificationName);
end;

procedure TFacade.RemoveCommand(NotificationName: string);
begin
  FController.RemoveCommand(NotificationName);
end;
{$ENDREGION}

procedure TFacade.SendNotification(NotificationName: string; Body: TValue;
    Kind: TValue);
begin
  NotifyObservers(TNotification.Create(NotificationName, Body, Kind))
end;

procedure TFacade.SendNotification(NotificationName: string; Body: TValue);
begin
  SendNotification(NotificationName, Body, TValue.Empty);
end;

procedure TFacade.SendNotification(NotificationName: string);
begin
  SendNotification(NotificationName, nil, TValue.Empty);
end;

procedure TFacade.NotifyObservers(Notification: INotification);
begin
  FView.NotifyObservers(Notification);
end;

initialization

TFacade.FStaticSyncRoot := TObject.Create;

finalization

TFacade.FStaticSyncRoot.Free;

end.
