# Voldex-Code-Test-Tycoon

--//List of BUGS--//



1. Upon walking onto pads, the player can buy builds without needing coins.
2. Paycheck machine doesn't payout the correct amount.
3. Dying doesn't reset coins appropriately and you can no longer grab coins or purchase more pads.
4. Sounds don't work.
5. The Billboard guis are not showing prices and are not disabled upon purchase.
6. Players can fall off the map.
7. Coins can go into the Negative.
8. Client debouncer was added after the InvokeServer which needs to be before that line.
9. There is no server debounce, that leaves the server trusting the client which is no good. 
10. Not necessarily a bug, but changing the pad touched event over to the client and then sending a RE to the server may help with overall performance.
