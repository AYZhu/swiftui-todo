# swiftui-todo

i built this to-do list app over the span of a feverish five or six hours in one day. all of the interesting code is in the `Shared` folder. it only really runs on iOS systems because of the dependency on `UIColor` for one very specific tinting characteristic, which is stupid, but i can't be bothered to fix it right now, especially since the iOS app runs on my Mac anyways. 

this replicates a Google Doc i have where tasks have three statuses - `ar` (action required), `wt` (waiting), and `dn`. the Google Doc actually offers more options for hierarchy of projects, but, again, this was mostly an experiment to see if i could write anything in SwiftUI, having last written a mobile app probably over four years ago on an Android platform, and only recently having acquired an Mac. it is unlikely it will receive improved features, such as a due date option, since this would take effort, although it may eventually receive a method of marking tasks as `cr`/`pr` (currently being worked on / priority). we will see.

this to-do list app reads its data from a JSON file hosted at http://alanyzhu.scripts.mit.edu/todo.json and depends on a PHP file hosted at at http://alanyzhu.scripts.mit.edu/todo-update.php. for completeness, the whole of that PHP file is here:

```
<?php
$rawInput = file_get_contents('php://input', 'r');
$fp = fopen('todo.json', 'w+');
fwrite($fp, $rawInput);
fclose($fp);
```

to run this with your own hosting solution, simply change the endpoints in `Shared/ModelData.swift`. or don't, and be subjected to the horrors that is my to-do list. it's up to you.
