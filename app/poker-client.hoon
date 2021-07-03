/-  *poker
/+  default-agent, dbug, *poker
|%
+$  versioned-state
    $%  state-zero
    ==
+$  state-zero
    $:  %0
        game=poker-game-state
        challenges-sent=(map ship poker-challenge)
        challenges-received=(map ship poker-challenge)
    ==
::
+$  card  card:agent:gall
::
--
%-  agent:dbug
=|  state=versioned-state
^-  agent:gall
=<
|_  =bowl:gall
+*  this      .
    def   ~(. (default-agent this %|) bowl)
    hc    ~(. +> bowl)
::
++  on-init
  ^-  (quip card _this)
  ~&  >  '%poker-client initialized successfully'
  `this
++  on-save
  ^-  vase
  !>(state)
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  ~&  >  '%poker-client recompiled successfully'
  `this(state !<(versioned-state old-state))
++  on-poke
  ::  ?>  (team:title [our src]:bowl)
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %noun
    ?+    q.vase  (on-poke:def mark vase)
        %print-state
      ~&  >  state
      ~&  >>  bowl  `this
      ::
        %print-subs
      ~&  >>  &2.bowl  `this
    ==
    ::
    %poker-client-action
    ~&  >  !<(client-action:poker vase)
    =^  cards  state
    (handle-client-action:hc !<(client-action:poker vase))
    [cards this]
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ~&  >>  "smth on {<wire>}"
  ?+    wire  (on-agent:def wire sign)
      [%game @ta @ta ~]
    ?+  -.sign  (on-agent:def wire sign)
        %fact
      =/  val=poker-game-state  !<(poker-game-state q.cage.sign)
      ~&  >>  "your game state is {<val>}"
      `this
    ==
    
  ==
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
::  start helper core
::
|_  bowl=bowl:gall
++  handle-client-action
  |=  =client-action:poker
  ^-  (quip card _state)
  ?-  -.client-action
    :: :poker-client &poker-client-action [%issue-challenge ~bus [game-id=100 challenger=~zod players=~[~zod ~bus] host=~zod type=%cash]]
    %issue-challenge
  ?>  (team:title [our src]:bowl)
  =.  challenges-sent.state  
    (~(put by challenges-sent.state) [to.client-action challenge.client-action])
  :_  state
    :~  :*  %pass  /poke-wire  %agent  [to.client-action %poker-client] 
            %poke  %poker-client-action  !>([%receive-challenge challenge=challenge.client-action])
          ==
      ==  
    ::
    ::
    %receive-challenge
  =.  challenges-received.state  
    (~(put by challenges-received.state) [challenger.challenge.client-action challenge.client-action])
  :_  state
    ~
    :: :poker-client &poker-client-action [%accept-challenge ~zod]
    ::
    %accept-challenge
  =/  challenge  
    (~(get by challenges-received.state) from.client-action)
  ?~  challenge
    :_  state
      ~[[%give %poke-ack `~[leaf+"error: no challenge from {<from.client-action>} exists"]]]
  =.  challenges-received.state
    (~(del by challenges-received.state) from.client-action)
  :_  state
    :~  :*  :: notify challenger that we've accepted
            %pass  /poke-wire  %agent  [from.client-action %poker-client]
            %poke  %poker-client-action  !>([%challenge-accepted by=our.bowl])
          ==
        :*  :: subscribe to path which game will be served from
            %pass  /poke-wire  %agent  [our.bowl %poker-client]
            %poke  %poker-client-action  !>([%subscribe game-id=game-id.u.challenge host=host.u.challenge])
          ==
      ==
    ::
    ::
    %challenge-accepted
  =/  challenge  
    (~(get by challenges-sent.state) by.client-action)
  ?~  challenge
    :_  state
      ~[[%give %poke-ack `~[leaf+"error: no challenge from {<by.client-action>} exists"]]]
  =.  challenges-sent.state
    (~(del by challenges-sent.state) by.client-action)
  :_  state
    :~  :*  :: register game with server
            %pass  /poke-wire  %agent  [host.u.challenge %poker-server]
            %poke  %poker-server-action  !>([%register-game challenge=u.challenge])
          ==
        :*  :: subscribe to path which game will be served from
            %pass  /poke-wire  %agent  [our.bowl %poker-client]
            %poke  %poker-client-action  !>([%subscribe game-id=game-id.u.challenge host=host.u.challenge])
          ==
      ==
    ::
    :: 
    %subscribe
  :_  state
    :~  :*  %pass  /game/(scot %ud game-id.client-action)/(scot %p host.client-action)
            %agent  [host.client-action %poker-server]
            %watch  /game/(scot %ud game-id.client-action)/(scot %p our.bowl)
          ==
      ==
  ==
--
