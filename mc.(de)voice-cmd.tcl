# Beta version, to be v1.4
##
# (de)Voice Command v1.4 by MC_8 - Carl M. Gregory <mc8@purehype.net>
#  This script will only work on eggdrop 1.5.5 and greater.
#
# My SVS Website - http://mc.purehype.net:81/
##

##
# Creates public triggers so one may voice him/her self.  Why not use /msg bot voice
#  you ask, well... AZ0R0S seems to want people without access to be able to voice
#  them selves.  As he said it, "all ladies get voice, the onjoin states `if you
#  are a lady please type: /msg #channel +v'"  Uh hu, sounds like he's running a
#  cat house (Hopefully I get in cheep?!).  Another usefull idea for this script
#  is for warez type channels.  My script mc.mp3voice works good for mp3 serving
#  because it goes by the standard ctcp SLOTS and ctcp MP3, but warez doesn't have
#  a standard other than almost every ftp advertisment contains *FTP*Online*.
#  You see where I'm going with that, set the +v trigger to *FTP*Online*.
##

##
# History
##
# v1.4 (11.14.01)
#  MC_8 - Upgraded SVS from v1.1 to v2.0.
#  MC_8 - Setup mc_pvc(limit) on a rotating schedule rather than the blocked
#         time format it had.
#  MC_8 - Changed channel flag from mc-voice-cmd to mc.voicecmd.
#  MC_8 - Fixed 'Tcl error [mc:pvc:ctcp]: called "mc:pvc:ctcp" with too many
#         arguments'.
#  MC_8 - Cleaned up the coding a bit.
#  MC_8 - Mustang97 - Script wasn't replying to any commands.
#
# v1.3.1 (06.27.01)
#  MC_8 - Eddie - Fixed `Tcl error [mc:pvc:msgm]: invalid command name "return1"`
#
# v1.3 (01.30.00)
#  MC_8 - Added SVS
#  MC_8 - In addition to "what flaged user do you want to allow", added a disallow
#         based off the same logics.
#  MC_8 - Removed the dynamic way of selecting what channels for this script to
#         be active on, can now set via dcc's .chanset command.
#  MC_8 - Changed the name from mc.pub-(de)voice-cmd.tcl to mc.(de)voice-cmd.tcl
#  MC_8 - Brew - Made the script able to pick up commands from public/msg/ctcp.
#
# v1.2.1 (04.15.00)
#  MC_8 - AZ0R0S - If someone is set to +q (quiet) and triggers a public voice commands.
#                  this script would +v-v that user.  Coded that instance into the mix
#                  so that it won't touch people that are +q.
# 
# v1.2 (03.30.00)
#  MC_8 - Added new veriable, mc_pvc(chans).
#  MC_8 - Added new veriable, mc_pvc(limit).
#  MC_8 - Fixed a minor problem with mc_pvc(flags).
#  MC_8 - AZ0R0S - Discovered this script wasn't reacting to the public command (the
#                  whole reasoning for this script.  Found mis coding in the script.
#                  That mis coding was also causing the bot to -v or +v to verious
#                  text that isn't even in the veriable sets.  Opsie!
# 
# v1.1 (03.28.00)
#  MC_8 - AZ0R0S - Added wild card support on the triggers.
#
# v1.0 (02.28.00)
#  MC_8 - AZ0R0S - Inital release.
##

##
# Settings
##
#

# Note:
#  There is one setting you set from dcc chat with the bot using .chanset.
#   <+/->mc.voicecmd   Setting this to +mc-voice-command on the specific channel
#                       will enable the channel to utalize this script.
#
#  Example from dcc chat with the bot:
#   .chanset #channel +mc.voicecmd

# Set what flaged users are able to use the command(s).  Set to -|- for anyone.
# Do not forget to specify the | for <global>|<channel> flag seperator.
set mc_pvc(flags) -|-

# Set what flaged users are not able to use the command(s).
# Set to -|- if you want no one ignored.  Do not forget to specify the | for 
# <global>|<channel> flag seperator.
set mc_pvc(ign:flags) dkq|dkq

# What triggers do you want to use for voice'n self?  Can have more
# than 1 trigger, just add a new line before the `}'.
set mc_pvc(!+v) {
 !voice
 !voiceme
 +v
 *I*am*female*
 *I*am*chick*
 *voice me*
}

# What triggers do you want to use for devoice'n self?  Can have more
# than 1 trigger, just add a new line before the `}'.
set mc_pvc(!-v) {
 !devoice
 !devoiceme
 -v
 *I*am*male*
}

# You can add other mode changes if you like.  Like on other networks, you
# can use the +q/-q flag.  If you want this script to use it...
#   set mc_pvc(!<flag change>) {
#    triggers
#   }
# Flag change would be +q/-q/... whatever flag change you wanna do on the user
# that the server supports.

# [0=no/1=yes] Do you want the script to listen for them commands via public?
set mc_pvc(pub) 1

# [0=no/1=yes] Do you want the script to listen for them commands via private message?
set mc_pvc(privmsg) 1

# [0=no/1=yes] Do you want the script to listen for them commands via ctcp?
set mc_pvc(ctcp) 0

# [0=no/1=yes] Do you want the triggers to be case sensative?
set mc_pvc(cs) 0

# How many times should one be allowed to access these commands?
# Syntax:  <number>:<seconds>    Example:  2:60  (2 commands every
#                                60 seconds per person)
set mc_pvc(limit) 2:60


## MC SVS (Script Version Service) v2.0 ##
# Do you want the bot to connection to MC_8's SVS to see if there are newer versions
# of this script avilable?  It will only tell you -- It's up to you to get the newest
# version (I decided not to auto update the code, there may be new features in the
# newest script that may require your attention).
# 0=no/1=yes
set mc_pvc(svs:enabled) 1

# Once a day the script will check with the SVS -- this specifies when
# that should happen.  The setting should be the hour (military).
# examples:
#  set mc_pvc(svs:check) 0   ;#This is at Midnight
#  set mc_pvc(svs:check) 5   ;#This is at 5am
#  set mc_pvc(svs:check) 13  ;#This is at 1pm
#  set mc_pvc(svs:check) 23  ;#This is at 11pm
set mc_pvc(svs:check) 3

# Upon finding a newer version of this script, who do you want this script
# to send a note to telling them of this newer version?
# If more than 1 user is to be notified, seperate each user with a
# ' ' (space).
set mc_pvc(svs:notify) "MC_8"

# Do you want even beta version notified to whomever you have set?  Or just
# stable releases of the script?
#  0 = Tell me about all version, even beta versions.
#  1 = Just tell me about new stable versions.
set mc_pvc(svs:stableonly) 0


#
##

##
# Coding
##
#

set mc_pvc(script)      "(de)Voice Command"
set mc_pvc(version)     "v1.4"
set mc_pvc(svs:script)  "(de)voice-cmd"
set mc_pvc(svs:version) "001004000000"
set mc_pvc(svs:server)  "mc.purehype.net"
set mc_pvc(svs:port)    "81"
set mc_pvc(svs:get)     "/"
set mc_pvc(svs:query)   "svs=$mc_pvc(svs:script)&version=$mc_pvc(svs:version)"

if {$numversion < "1050500"} {
 putlog "$mc_pvc(script) $mc_pvc(version) by MC_8 will only work on eggdrop 1.5.5 or greater."
 putlog "$mc_pvc(script) $mc_pvc(version)  will not work with eggdrop $version."
 putlog "$mc_pvc(script) $mc_pvc(version)  not loaded."
 return 1
}

setudef flag mc.voicecmd

proc mc:pvc:inter:det {nick uhost hand chan arg} {
 global mc_pvc botnick
 scan $uhost {%[^@]@%s} ident host
 if {((![matchattr $hand $mc_pvc(flags) $chan]) && ($mc_pvc(flags) != "-|-")) ||
     ([matchattr $hand $mc_pvc(ign:flags) $chan]) ||
     ([mc:pvc:inter:chanflag $chan mc.voicecmd]) ||
     ([mc:pvc:limit $host $chan]) ||
     (![isop $botnick $chan])} {return 0}
 if {!$mc_pvc(cs)} {set arg [string tolower $arg]}
 foreach veriable [array names mc_pvc] {
  if {[string index $veriable 0] != "!"} {continue}
  set set $mc_pvc($veriable)
  if {!$mc_pvc(cs)} {set set [string tolower $set]}
  foreach array [split $mc_pvc($veriable) \n] {
   set array [string trim $array " "] 
   if {![string match $array $arg] || ($array == "")} {continue}
   pushmode $chan [string range $veriable 1 2] $nick
   return 1
  }
 }
}

proc mc:pvc:limit {host chan} {
 global mc_pvc mc_pvcl
 set host [string tolower $host]
 set chan [string tolower $chan]
 scan $mc_pvc(limit) {%[^:]:%s} a b
 if {(!$a) || (!$b)} {return 0}
 if {[info exists mc_pvcl($host:$chan)]} {
  if {$mc_pvcl($host:$chan) >= $a} {return 1}
  incr mc_pvcl($host:$chan) 1
 } else {
  set mc_pvcl($host:$chan) 1
  utimer $b [list incr mc_pvcl($host:$chan) -1]
 }; return 0
}

proc mc:pvc:inter:chanflag {channel flag} {
 if {![validchan $channel]} {return -code error "no such channel record"}
 set list [channel info $channel]
 for {set i 0} {![regexp -- {^[0-9]*:[0-9]*$} [lindex $list $i]]} {incr i} {}
 for {} {[regexp -- {^[0-9]*:[0-9]*$} [lindex $list $i]]} {incr i} {}
 set list [lrange $list $i end]
 foreach info [string tolower $list] {
  if {[string range $info 1 end] != [string tolower $flag]} {continue}
  if {[string index $info 0] == "-"} {
   return 0
  } elseif {[string index $info 0] == "+"} {return 1} else {return 2}
 };return -1
}

bind pubm - * mc:pvc:pubm
proc mc:pvc:pubm {nick uhost hand chan arg} {
 global mc_pvc
 if {$mc_pvc(pub)} {mc:pvc:inter:det $nick $uhost $hand $chan $arg}
}

bind msgm - * mc:pvc:msgm
proc mc:pvc:msgm {nick uhost hand arg} {
 global mc_pvc
 if {$mc_pvc(privmsg)} {
  foreach chan [channels] {
   if {[onchan $nick $chan]} {mc:pvc:inter:det $nick $uhost $hand $chan $arg}
  }
 }
}

bind raw - PRIVMSG mc:pvc:ctcp
proc mc:pvc:ctcp {from key arg} {
 scan "$arg\003" "%s :%\[^\003\]" dest arg
 if {![regexp -- "^\001(.*)\001\$" $arg a text]} {return 0}
 scan "$text\003" "%s %\[^\003\]" keyword text
 scan $from {%[^!]!%[^@]@%s} nick ident host
 mc:pvc:inter:det $nick $ident@$host [nick2hand $nick] $dest "$key $arg"
}

## SVS v2.0
if {(![info exists mc_pvc(svs:enabled)]) ||
    (![regexp -- {^(0|1)$} $mc_pvc(svs:enabled)])} {set mc_pvc(svs:enabled) 0}
if {(![info exists mc_pvc(svs:check)]) ||
    ([regexp -- {[^0-9]} $mc_pvc(svs:check)])} {set mc_pvc(svs:check) 0}
if {![info exists mc_pvc(svs:notify)]} {set mc_pvc(svs:notify) $owner}
if {(![info exists mc_pvc(svs:stableonly)]) ||
    (![regexp -- {^(0|1)$} $mc_pvc(svs:stableonly)])} {set mc_pvc(svs:stableonly) 0}
foreach bind [binds mc:pvc:svs:time] {
 unbind [lindex $bind 0] [lindex $bind 1] [lindex $bind 2] [lindex $bind 4]
}
foreach command [info commands mc:pvc:svs:time] {rename $command ""}
if {$mc_pvc(svs:enabled)} {
 if {($mc_pvc(svs:check) > "23") || ($mc_pvc(svs:check) < "0")} {set mc_pvc(svs:check) 00}
 if {[string length $mc_pvc(svs:check)] == "1"} {set mc_pvc(svs:check) 0$mc_pvc(svs:check)}
 bind time - "00 $mc_pvc(svs:check) *" mc:pvc:svs:time
 proc mc:pvc:svs:time {{args ""}} {
  global mc_pvc
  if {[catch {socket -async $mc_pvc(svs:server) $mc_pvc(svs:port)} sid]} {;\
   putlog "SVS Error\[$mc_pvc(svs:script)/$mc_pvc(svs:version)\]:  $sid"
   return 1
  }
  fconfigure $sid -blocking 0 -buffering line
  set tout [after 60000 "mc:pvc:svs:interface $sid timeout"]
  fileevent $sid readable "mc:pvc:svs:interface $sid $tout"
  puts $sid "GET $mc_pvc(svs:get)?$mc_pvc(svs:query) HTTP/1.0\
           \nHost: $mc_pvc(svs:server)\n"
  flush $sid
 }
}
proc mc:pvc:svs:interface {sid tout} {
 global mc_pvc
 if {$tout == "timeout"} {
  putlog "SVS Warning\[$mc_pvc(svs:script)/$mc_pvc(svs:version)\]:  SVS Server timed out."
  close $sid
  return 0
 }; after cancel $tout
 set temp 0
 while {![eof $sid]} {
  gets $sid get
  if {$temp < "2"} {
   if {$get == ""} {incr temp; if {$temp == "1"} {set temp 2}}
   continue
  }; if {$get == ""} {continue}
  switch -- [lindex $get 0] {
   003 {
    set reply [lrange $get 1 end]
    if {[lindex $reply 0] != $mc_pvc(svs:script)} {
     putlog "SVS Error\[$mc_pvc(svs:script)/$mc_pvc(svs:version)\]:  SVS Server sent wrong info, got [lindex $reply 0]"
     break   
    }
    if {$mc_pvc(svs:stableonly)} {
     set temp [string range $mc_pvc(svs:version) 0 8]999
    } else {set temp [string range $mc_pvc(svs:version) 0 11]}
    if {[lindex $reply 1] > $temp} {
     set note [lindex $reply 5]
     regsub -- %0 $note [lindex $reply 0] note
     regsub -- %1 $note [lindex $reply 1] note
     regsub -- %2 $note [lindex $reply 2] note
     regsub -- %3 $note [lindex $reply 3] note
     regsub -- %4 $note [lindex $reply 4] note
     regsub -- %version $note $mc_pvc(version) note
     foreach to [split $mc_pvc(svs:notify) ",; "] {
      if {$to == ""} {continue}
      regsub -- %nick $note $to outnote
      if {[string match *$outnote* [set unotes [notes $to -[notes $to]]]]} {
       set temp 0
       foreach unote $unotes {
        if {$outnote == [lindex $unote 2]} {set temp 1; break}
       }; if {$temp} {continue}
      }
      switch -- [sendnote SVS $to $outnote] {
       0 {
        if {![validuser $notify]} {set x "invalid user"} else {set x "unknown error"}
        putlog "SVS Error\[$mc_pvc(svs:script)/$mc_pvc(svs:version)\]:  Trying to send note to $to, $x."
       }
       3 {putlog "SVS Error\[$mc_pvc(svs:script)/$mc_pvc(svs:version)\]:  Trying to send note to $to, notebox too full!"}
      }
     }
    }
   }
  }
 }; close $sid
}
## ^

putlog "$mc_pvc(script) $mc_pvc(version) by MC_8 loaded."
