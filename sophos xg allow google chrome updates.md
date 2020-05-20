# Allow Google Chrome updates behind Sophos XG 17.5 Firewall

## Problem
The default Sophos XG v17.5 web protection settings block google chrome downloads and updates.

## Solution
Create a Web filtering exception for 'tools.google.com' and 'dl.google.com'

* Login to your firewall
* Select 'Web' -> 'Exceptions
* Click 'Add Exception'
* Configure as shown below
  * URL Patterns
  
    ```
    ^tools\.google\.com
    ^dl\.google\.com
    ```
    
    * Skip the selected checks or actions
  
    ```
    Policy checks
    ```
    
    * Click 'Save' at the bottom left
    
    [screenshot](img/sophos%20xg%20google%20chrome%20exception.png?raw=true)
