{
  PureMVC Delphi Port by Jorge L. Cangas <jorge.cangas@puremvc.org>
  PureMVC - Copyright(c) 2006-11 Futurescale, Inc., Some rights reserved.
  Your reuse is governed by the Creative Commons Attribution 3.0 License
}

unit PureMVC.Interfaces.INotification;

interface

uses
  RTTI;

type

  /// <summary>
  /// The interface definition for a PureMVC Notification
  /// </summary>
  /// <remarks>
  /// <para>PureMVC does not rely upon underlying event models</para>
  /// <para>The Observer Pattern as implemented within PureMVC exists to support event-driven communication between the application and the actors of the MVC triad</para>
  /// <para>Notifications are not meant to be a replacement for Events.
  /// Generally, <c>IMediator</c> implementors place event handlers on their
  /// view components, which they then handle in the usual way.
  /// This may lead to the broadcast of <c>Notification</c>s to trigger <c>ICommand</c>s
  /// or to communicate with other <c>IMediators</c>.
  /// <c>IProxy</c> and <c>ICommand</c> instances communicate with each other
  /// and <c>IMediator</c>s by broadcasting <c>INotification</c>s</para>
  /// </remarks>
  /// <see cref="PureMVC.Interfaces.IView"/>
  /// <see cref="PureMVC.Interfaces.IObserver"/>
  INotification = interface
    ['{CFF56816-6DB6-4FC4-9895-4728BA0BE3C6}']
    function GetBody: TValue;
    procedure SetBody(Value: TValue);
    function GetKind: TValue;
    procedure SetKind(const Value: TValue);
    function GetName: string;
    procedure SetSender(const Value: TObject);
    function GetSender: TObject;

    /// <summary>
    /// The Sender of the <c>INotification</c> instance. Introduced to be
    /// more "Delphi idiomatic"
    /// </summary>
    /// <remarks>No setter, should be set by constructor only</remarks>
    property Sender: TObject
      read GetSender;
    /// <summary>
    /// The name of the <c>INotification</c> instance
    /// </summary>
    /// <remarks>No setter, should be set by constructor only</remarks>
    property name: string
      read GetName;

    /// <summary>
    /// The body of the <c>INotification</c> instance
    /// </summary>
    property Body: TValue
      read GetBody
      write SetBody;

    /// <summary>
    /// The type of the <c>INotification</c> instance
    /// </summary>
    property Kind: TValue
      read GetKind
      write SetKind;

    /// <summary>
    /// Get the string representation of the <c>INotification</c> instance
    /// </summary>
    /// <returns>The string representation of the <c>INotification</c> instance</returns>
    function ToString: string;
  end;

implementation

end.
