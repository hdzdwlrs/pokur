/+  pokur
=,  format
|_  upd=game-update:pokur
++  grab
  |%
  ++  noun  game-update:pokur
  --
++  grow
  |%
  ++  noun  upd
  ++  json
    ?-  -.upd
      %update
      %-  pairs:enjs
      :~  ['in_game' [%b %.y]]
          ['game_is_over' [%b game-is-over.game.upd]]
          ['id' [%s (scot %da game-id.game.upd)]]
          ['host' (ship:enjs host.game.upd)]
          ['type' [%s type.game.upd]]
          ['time_limit_seconds' (numb:enjs time-limit-seconds.game.upd)]
          ['players' [%a (turn players.game.upd ship:enjs)]]
          ['paused' [%b paused.game.upd]]
          :-  'update_message'
          %-  pairs:enjs
          :~  ['msg' (tape:enjs -.update-message.game.upd)]
              :-  'hand'
              :-  %a
              %+  turn
                winning-hand.update-message.game.upd
              |=  c=pokur-card:pokur
              %-  pairs:enjs 
              :~  ['val' (numb:enjs (card-val-to-atom:pokur -.c))]
                  ['suit' [%s +.c]]
              ==
          ==
          ['my_hand_rank' (tape:enjs my-hand-rank.upd)]
          ['hands_played' (numb:enjs hands-played.game.upd)]
          :-  'chips' 
          %-  pairs:enjs 
          %+  turn
            chips.game.upd
          |=  [s=ship stack=@ud committed=@ud acted=? folded=? left=?]
            :-  `@t`(scot %p s)
            %-  pairs:enjs 
            :~  ['stack' (numb:enjs stack)]
                ['committed' (numb:enjs committed)]
                ['acted' [%b acted]]
                ['folded' [%b folded]]
                ['left' [%b left]]
            ==
          :-  'pots' 
          :-  %a
          %+  turn
            pots.game.upd
          |=  p=[@ud (list ship)]
          %-  pairs:enjs 
          :~  ['val' (numb:enjs -.p)]
              ['players_in' [%a (turn +.p ship:enjs)]]
          ==
          ['current_round' (numb:enjs current-round.game.upd)]
          ['current_bet' (numb:enjs current-bet.game.upd)]
          ['min_bet' (numb:enjs (snag current-round.game.upd min-bets.game.upd))]
          ['last_bet' (numb:enjs last-bet.game.upd)]
          :-  'board'
          :-  %a
          %+  turn
            board.game.upd
          |=  c=pokur-card:pokur
          %-  pairs:enjs 
          :~  ['val' (numb:enjs (card-val-to-atom:pokur -.c))]
              ['suit' [%s +.c]]
          ==
          :-  'hand'
          :-  %a
          %+  turn
            my-hand.game.upd
          |=  c=pokur-card:pokur
          %-  pairs:enjs 
            :~  ['val' (numb:enjs (card-val-to-atom:pokur -.c))]
                ['suit' [%s +.c]]
            ==
          ['whose_turn' (ship:enjs whose-turn.game.upd)]
          ['dealer' (ship:enjs dealer.game.upd)]
          ['small_blind' (ship:enjs small-blind.game.upd)]
          ['big_blind' (ship:enjs big-blind.game.upd)]
      ==
      %left-game
      %-  pairs:enjs
      :~  ['in_game' [%b %.n]]
      ==
      %msgs
      %-  pairs:enjs
      :~  :-  'messages'
          :-  %a
          %+  turn
            msg-list.upd
          |=  [from=ship msg=tape]
          %-  pairs:enjs 
          :~  ['from' (ship:enjs from)]
              ['msg' (tape:enjs msg)]
          ==
      ==
    ==
  --
++  grad  %noun
--