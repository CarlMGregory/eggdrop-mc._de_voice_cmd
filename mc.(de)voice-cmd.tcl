##
# (de)Voice Command v1.3 by MC_8 (Carl M. Gregory) <gregory@worldinter.net>
#  for eggdrop 1.5.0 and greater
#
# My SVS Website - http://mc.purehype.net/
##

##
#  This script requested by AZ0R0S.
#  Creates public triggers so one may voice him/her self.  Why not use /msg bot voice
#   you ask, well... AZ0R0S seems to want people without access to be able to voice
#   them selves.  As he said it, "all ladies get voice, the onjoin states `if you
#   are a lady please type: /msg #channel +v'"  Uh hu, sounds like he's running a
#   cat house (Hopefully I get in cheep?!).
#
#  Note to the coders, I coded this script in such a way that you can make
#  it based off any mode change (+b/+v/+o/-b...) whatever.  +v is as far as I'm going,
#  If you choose to put them enabled those... your on your own, just leeting you know
#  it's geared to do such things on purpose.
#
##

##
# History
##
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
#   <+/->mc-voice-cmd   Setting this to +mc-voice-command on the specific channel
#                       will enable the channel to utalize this script.
#
#  Example from dcc chat with the bot:
#   .chanset #channel +mc-voice-cmd

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

## MC SVS (Script Version Server) v1.1 ##
# Do you want the bot to connection to MC_8's SVS to see if there are newer versions
# of this script avilable?  It will only tell you -- It's up to you to get the newest
# version (I decided not to auto update the code, there may be new features in the
# newest script that may require your attention).
# 0=no/1=yes
set mc_pvc(svs:enabled) 1

# Once a day the script will check with the SVS -- this specifies when
# that should happen.  The setting should be the hour (military).
# examples:
#  set mc_pvc(svs:check) 0  ;#This is at Midnight
#  set mc_pvc(svs:check) 5  ;#This is at 5am
#  set mc_pvc(svs:check) 13  ;#This is at 1pm
#  set mc_pvc(svs:check) 23  ;#This is at 11pm
set mc_pvc(svs:check) 3

# Upon finding a newer version, who do you want to notify via note?
# Seperate each user with a " " (space).
set mc_pvc(svs:notify) "MC_8"


#
##

##
# Coding
##
#

set mc_pvc(version) v1.3
set mc_pvc(svs:script) "(de)voice-cmd 001003000000"
set mc_pvc(svs:server) "mc.purehype.net 8085"

if {$numversion < "1050000"} {
 putlog "(de)Voice Command $mc_pvc(version) by MC_8 is for eggdrop 1.5+ series only."
 putlog "(de)Voice Command $mc_pvc(version) will not work with eggdrop $version."
 putlog "(de)Voice Command $mc_pvc(version) not loaded."
 return 1
};setudef flag mc-voice-cmd

proc mc:pvc:inter:det {nick uhost hand chan args} {
 global mc_pvc
 set chan [string tolower $chan]
 if {![matchattr $hand $mc_pvc(flags) $chan] && ($mc_pvc(flags) != "-|-")} {return}
 if {[matchattr $hand $mc_pvc(ign:flags) $chan]} {return}
 if {![mc:pvc:inter:chanon $chan]} {return}
 if {[mc:pvc:limit [string range $uhost [expr [string last @ $uhost]+1] e] $chan]} {return}
 if {!$mc_pvc(cs)} {set args [join [string tolower $args]]} {set args [join $args]}
 foreach veriable [array names mc_pvc] {
  if {[string index $veriable 0] != "!"} {continue}
  if {!$mc_pvc(cs)} {set mc_pvc($veriable) [string tolower $mc_pvc($veriable)]}
  foreach array [split $mc_pvc($veriable) \n] {
   set array [string trim $array " "] 
   if {![string match "$array" "$args"] || ($array != "")} {continue}
   pushmode $chan [string range $veriable 1 e] $nick
   return
  }
 }
}

proc mc:pvc:limit {uhost chan} {
 global mc_pvc mc_pvcl
 set uhost [string tolower $uhost]
 set chan [string tolower $chan]
 set a [lindex [split $mc_pvc(limit) :] 0]
 set b [lindex [split $mc_pvc(limit) :] 1]
 if {$a == "0"} {return 0}
 if {[info exists mc_pvcl($uhost:$chan)]} {
  if {$mc_pvcl($uhost:$chan) == $a} {return 1}
  incr mc_pvcl($uhost:$chan) 1
 } {
  set mc_pvcl($uhost:$chan) 1
  utimer $b "catch {unset mc_pvcl($uhost:$chan)}"
 } ; return 0
}

proc mc:pvc:inter:chanon {chan} {
 set chan [string tolower $chan]
 foreach info [channel info $chan] {
  if {[string range $info 1 e] == "mc-voice-cmd"} {
   if {[string index $info 0] == "-"} {return 0} {return 1}
  }
 };return 0
}

bind pubm - * mc:pvc:pubm
proc mc:pvc:pubm {nick uhost hand chan args} {
 global mc_pvc
 if {$mc_pvc(pub)} {mc:pvc:inter:det $nick $uhost $hand $chan $args;return 1}
}

bind msgm - * mc:pvc:msgm
proc mc:pvc:msgm {nick uhost hand args} {
 global mc_pvc
 if {$mc_pvc(privmsg)} {
  foreach chan [channels] {
   if {[onchan $nick $chan]} {mc:pvc:inter:det $nick $uhost $hand $chan $args;return1}
  }
 };return 0
}

bind ctcp - * mc:pvc:ctcp
proc mc:pvc:ctcp {nick uhost dest key args} {
 global mc_pvc botnick
 if {[string tolower $botnick] != [string tolower $dest]} {return}
 if {$mc_pvc(ctcp)} {
  foreach chan [channels] {
   if {[onchan $nick $chan]} {mc:pvc:inter:det $nick $uhost $hand $chan "$key [join $args]"}
  }
 };return 0
}

if {$mc_pvc(svs:enabled)} {
 if {($mc_pvc(svs:check) > "23") || ($mc_pvc(svs:check) < "0")} {set mc_pvc(svs:check) 00}
 if {[string length $mc_pvc(svs:check)] == "1"} {set mc_pvc(svs:check) 0$mc_pvc(svs:check)}
 bind time - "00 $mc_pvc(svs:check) * * *" mc:pvc:svs:time
 proc mc:pvc:svs:time {min hour day month year} {
  global mc_pvc
  catch {control [connect [lindex $mc_pvc(svs:server) 0] [lindex $mc_pvc(svs:server) 1]] mc:pvc:svs:interface}
 }
}
proc mc:pvc:svs:interface {idx args} {
 global mc_pvc;set args [join $args]
 switch -- [lindex $args 0] {
  "" {return 1}
  000 {putdcc $idx q}
  002 {putdcc $idx [lindex $mc_pvc(svs:script) 0]}
  003 {
   set args [lrange $args 1 e]
   if {[lindex $args 0] != [lindex $mc_pvc(svs:script) 0]} {return 0}
   if {[lindex $args 1] > [lindex $mc_pvc(svs:script) 1]} {
    set note [mc:pvc:svs:replace [lindex $args 7] "%0 {[lindex $args 0]} %1 {[lindex $args 1]} %2 {[lindex $args 2]}"]
    set note [mc:pvc:svs:replace $note "%3 {[lindex $args 3]} %4 {[lindex $args 4]} %5 {[lindex $args 5]}"]
    set note [mc:pvc:svs:replace $note "%6 {[lindex $args 6]} %8 {[lindex $args 8]} %version {$mc_pvc(version)}"]
    set note [mc:pvc:svs:replace $note "%9 {[lindex $args 9]} %10 {[lindex $args 10]} %11 {[lindex $args 11]}"]
    set note [mc:pvc:svs:replace $note "%12 {[lindex $args 12]} %13 {[lindex $args 13]} %14 {[lindex $args 14]}"]
    set note [mc:pvc:svs:replace $note "%15 {[lindex $args 15]} %16 {[lindex $args 16]} %17 {[lindex $args 17]}"]
    set note [mc:pvc:svs:replace $note "%18 {[lindex $args 18]} %19 {[lindex $args 19]} %20 {[lindex $args 20]}"]
    foreach notify [join [split $mc_pvc(svs:notify) ",;"]] {
     switch -- [sendnote SVS $notify [mc:pvc:svs:replace $note "%nick {$notify}"]] {
      0 {putlog "MC SVS for [lindex $mc_pvc(svs:script) 0] had some errors updating $notify on current version of script; unknown reason!"}
      3 {putlog "MC SVS for [lindex $mc_pvc(svs:script) 0] had some errors updating $notify on current version of script; notebox too full!"}
     }
    }
   } ; putdcc $idx q
  }
 } ; return 0
}
proc mc:pvc:svs:replace {string subs} {
 if {[llength $subs] == "1"} {set subs [lindex $subs 0]}
 for {set i 0} {[lindex $subs $i] != ""} {incr i 2} {
  regsub -all -- [lindex $subs $i] $string [lindex $subs [expr $i+1]] string
 } ; return $string
}

putlog "(de)Voice Command $mc_pvc(version) by MC_8 loaded."