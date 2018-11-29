3285329 (HEAD -> dev-0.5, origin/dev-0.5)  Adding ActIt tests
2af51f3 Merge 40446db1093805dd9069c23734efa50a5c4d282f
a560fc4 (migrate-sources-to-tonel) sources migrated
40446db (origin/master, master) Configurations
a8a663e Tesstsss
3134e64 Passing to profile-object
e72d0f2 Profiles
f038a8b Timelimit
9324eef increasgin the wait. Maybe in command line things happen too fast?
31a5898 Some clean up in the browser
3ee64dd testsss
2ab23be  Modifiying building on travis conf
716e74d Change the error management. Unhandled error is too much. It cannnot be catched by any default strategy, only catched by on:UnhanledError.
9b19354 Repasing the tests
211dec2 sources migrated
bce796e Default handler behaviour
7af0e59 should check this
340639a Unhandled error is not managed by anymanagement.
df7462b Default actor exception handler
5cb3371 Add task UI Runner. This runner schedule tasks into the WorldState. Add testing methods. Add Actor with different processing strategies. So far, if an actor has a worker with nonempty queue, it fails when changing to UI or LocalThread mode.
2699de6 Merge pull request #42 from sbragagnolo/dev-0.5-features/actors
1b4ffce (origin/dev-0.5-features/actors) traits
25bdf2a actit
23bb851 Builderman
660bd29 Add actit into the basel ine
cc65e94 Merge pull request #40 from sbragagnolo/dev-0.5-features/actors
fd3ed3b Actor behaviour becomes a trait
af83bf7 First draft on actors
ea4efd0 creating branch 05
773f198 Merge pull request #39 from sbragagnolo/feature/messageSendAndTests
5680028 (origin/feature/messageSendAndTests) Some accessor for adding support for actors
820bbb9 - Better configuration for the prorfiles - TKTRawProcess/ TKTContextHolders use weak arrays now . - TKTRawProcess related tests use process:during:
4d6b5bb * Moving things to task fashion * making red tests to green
67ef97a Merge pull request #38 from sbragagnolo/dev-0.4.1
a563c54 Merge pull request #35 from reservoir-dogs-lille/master
a9255a7 Master process holder points now to a regular reference (Not weak).
d2d3ec7 Add a step delay at the superclass level
aa6b8b7  Test correction
05731ce Test correction
30e7154 Service test time delays adjusted
54e3646 Add default time delay and delay setter
a6dcdc9  Baseline was pointing to strict taskit
70c833e (tag: v0.4) Travis for pharo 6 and 7
2e58192 These tests should be failing!
9e65310 Taking tests that are for next version out
33c88cf testWorkerPoolDoesNotExceedPoolSize seems to be working.
017bbf2 Tests marked as expected failure
351e6c0 Tests for realease
d0bf3f0 Runner out!
e86d12a All the test cases inherit from TKTTestCase
9debb5b Reset.
9df52e6 Test was failinggg
ae56ef4 Name to printString
d5bc863 Testsss to green
b436e0e Changes v04
38df395 Add profile setup
da57b12  More TKTConf
ea0df07 readme + conf
045b753 Tests are working weirdly. but working
19bfc92 Enhancing tests
72b14b1  Services moved to kernel
80b6ecf Move tests to the minimal package (Needed by the watchdog of the common pool worker)
94374b4 Taskit TKTWatchDog
c12dd22 Testss!
27a0cab Tests! + Increase decrease of workers
086561f Enhancing the watchdog of the common queuee worker pool
38b02bc Cleaning up the mess :)
300a3be Full load by default
dafb4b3 Remove the singletons
527a87e Add common queue worker pool
baedd59 Future works with the TKTConfiguration holder!
ac6602f Working on tests for TKTConfiguration
f3a36e3 Changing all singletons to configuration holder
875039b Taking the debugger mechanics out from future and into a specific runner.
9d752b7 Tryihg iceberg's new branch.
cf80bfe (tag: v0.3) Merge pull request #27 from sbragagnolo/dev-0.3
7056b0d Signal errors in tests before deploy them .
da589a7 Adaption Tab And TabManager changed names
43f0288 Merge branch 'dev-0.3' into pre-release-3-scale
65adc0b Filetree bla
7899b9a Merge pull request #24 from estebanlm/pre-release-3-scale
a7c6533 Merge pull request #23 from theseion/dev-0.3
bac1de0 add verbose tasks (they do not redirect stdout/stderr so you still has the console)
c455390 OSTask accept workingDirectory
ac030fd fixed link markup
1e15680 added documentation on TKTDebugger
809a615 * added missing thread link construction
ec854f6 XMerge branch 'theseion-dev-0.3' into dev-0.3
d6ca2a6 * added 'tests' group for loading tests (will load 'default') * 'development' now also loads 'tests'
4602769 * added debugger package * added 'default' group that does not include the debugger * added 'debug' group that loads the debugger on top of 'minimal' * added 'development' group that loads everything, including the debugger
cc745cd * implementation of the thread debugger for TaskIt * categorised some uncategorised methods * made choice of process class to use dynamic, so that the TaskIt debugger an be loaded independantly
65a2ffa fixed spelling of 'IT' in manifests to fix duplicate entries on case insensitive filesystem
a75695e deleted manifests so that they can be renamed (case insensitive file system)
cf61d01 "Merge commit b1fe8069da93d6234778c6980a39ffbdd5b05227"
5e2454e - Errors should be freezed when passed to a future callback- Retry should rethrow exception
b1fe806  Fixing path bug
239e194 Merge branch 'dev-0.3' of github.com:sbragagnolo/taskit into dev-0.3
7d7df06  it changes the baseline
eef7a40 fixed test spec
820041a removed temporarily taskitshell because smalltalk ci refuses to load it
9b689b1 trying to load all and run all tests
68b6c81 added directive to load taskit shell
f962ab3 trying to make run shell tests too
829fa11 trying putting back the smalltalk ston file
d9e8087 using the smalltalk_config key properly
4349f9a moving to smalltalk ci https://github.com/hpi-swa/smalltalkCI
14fc76c - Some method categorizations- Executors should note if they are busy or free
a90329a  Pushing travis
ea995d8  making travis to work. Tests!
8edb293  Travisss
94e2b1c  brrrp
602f19d  adding shell to the tests
b1be47b Merge branch 'dev-0.3' of github.com:sbragagnolo/taskit into dev-0.3
306e125  Taskit shell baseline
ce5f339 Added testing methods to check future results
c625348 Added TaskItRetry
d35cbd1 Task execution should capture all Exceptions
93fb231 - Should manage Exceptions and not Errors- Doing a pass during retry breaks because contexts of the exception are already terminated
f24e5a8  Fixing tests
08db564  Still breaking tests, but less violently :D
135c484  Support for executing bash as tasks
ffbc099 Issue #20. Worker pool should initialize on loading instead of lazily. Otherwise tests will kill the created processes.
270ea5a Added taskit retry tests
2137f2f Importing package TaskItRetry-Tests
e8a1980 Importing package TaskItRetry
f21ffb9 "Merging with df7ac3d1500fa193aa027089d0ee86a43f132601"
fa5b4c0 Added recoverWith: combinator
df7ac3d  Manifest changes name from TaskIT to TaskIt. Shell package
bf2299e Fix for #19. Increment sleep time to guarantee service will start running.
7a58b5c Fix for Issue #18. Should do clean  GC before collecting the instances.
b47ac6b "Merge commit 8356d0bf8332e0aa53edc7605a83be1bf7f95ad9"
f847950 Fix Issue #18.
8356d0b Merge branch 'master' of github.com:sbragagnolo/taskit into dev-0.3
6283af8 Added memory leak tests
8cd6af9 Added memory leak tests
cad69d1 Added memory leak tests
188968a Issue #15. Fixed worker's, pool's and worker process' names.
45fe1b7 (tag: v0.2.1, tag: v0.2) See issue #9: Updated versions in download section
539051c added changes log v0.2
c467240 Update README.md
9680551 Update README.md
07dc6ff Merge branch 'dev-0.2' of github.com:sbragagnolo/taskit into dev-0.2
18ed3b1  Set some defaults. Add images for doc/ Issue #10
fdca4b7 Fix for issue #11
a2569ca  Baseline fixed (Typo )
937ccde  Baseline + Processes + Browser
98bbaee  Merging  dev-0.2. with TKTPRocess branch. Solves issue #2
d661f37 Issue #8. Adding reset global to clean the global worker pool and avoid leaks due to a non executing worker pool.
265d201 Added class comments
00a1579 Added class comments
b7b7bb0 1-[TaskIt]  Assigns a default name to the workers. 2-[TaskItBrowser] Comments Task and Job columns in the TKTProcessDataSource and TKTFastTableProcess. They will be abailable again next version . 3-[TaskItProcesses] It adds isTerminate in TKTProcess for polymorphism with Process. Sets TKTProcess name into the Process during it creation . Defines a default name, but it allows to overrite it
9f232a4 Issue #1:Added basic services implementation documentation.
c71c0fb Testing mock and parameterized services
7b5c852 Issue #5. Suspending tests temporarily between collections to allow running of finialization.
84d2081 Issue #5. Adding tests to test garbage collection of workers of a pool.
780f845 Fix issue #3. Fixed test script
7061932 Fix for issue #3.renamed baseline in install script.
7fc78db Fix issue #5. testing that workers of a pool are correctly collected after pool is collected.
6bd7c27 Fix issue #5. testing that workers of a pool are correctly collected after pool is collected.
0d1cf9c Fix issue #5. testing that workers of a pool are correctly collected after pool is collected.
e74d946 Fix issue #5. testing that workers of a pool are correctly collected after pool is collected.
a75f177  After dicussing with Guille it looks like .filetree is needed. So here it is .
b699663  Travis should work with this change
2918e88 Merge branch 'master' of github.com:sbragagnolo/taskit into dev-0.2
0ea2b43 updated installation instructions+
12b9944 removed old baseline
8d8584d Importing package BaselineOfTaskIt
d5ab37c - Added testing method #isEmpty in Worker- Worker pool should create workers named by him- Service should create workers named by them
2001cd7 - Added testing method #isEmpty in Worker- Worker pool should create workers named by him- Service should create workers named by them
d86215a  Ok, it was not baselineOfTaskIT but BaslineOfTaskIT2 :P. Backward compatibiliy
c23ac91  Install packages was pointing to BaselineOfTaskIt, but it is BaselineOfTaskIT
7182912  Privs and stauts
860b27c  Travis configuration
9d58fca  Travis
4c8303a Services have a setup and tear down
ca9750a Services have a setup and tear down
1601eea Services have a setup and tear down
dae4f2b renamed packages TaskIT2 -> TaskIt
35b4f95 Importing package TaskItServices-Tests
b894408 Importing package TaskItServices
6fcbabe Importing package TaskItProcesses-Tests
e9f15e4 Importing package TaskItProcesses
4dd9825 Importing package TaskItBrowser
b197afb Importing package TaskITTools
8276c50 Importing package TaskIt-Tests
b37495c Importing package TaskIt
38597ec moved title
6d9ef79 added section on default task runners
c91eb24 added syntax coloring
a062869 added download section
4358aaf updated baseline to latest package names
0810711 removed unused configurations
90be3fd Added combinators for collections of futures- OrderedCollection[Future] -> Future[OrderedCollection]- reduce a collection of futures -> future of a reduced collection
eee2de1 fixe andThen example
13b45ba Refactored task cancellation into task execution states
29f09e3 Refactored task cancellation into task execution states
1bae6ca Future creation is a task execution responsibility
87d3903 renamed combinators section
a6ba1b1 flatten both combinator sections
d74a31f pass on doc
bcc1c55 fixed writing in the first paragraphs
d89feb7 fixed typo is -> if
3d2afed removed old section
ba3c7ea Commented Task execution classes
01574ab Restored runner hierarchy:  - TKTWorkerProcess does not need to be a subclass of TKTRunner anymore
e1f59f0 implemented task cancellation via task executions
97a6feb Re-Added the TaskExecution abstraction to help in managing the current task runner and task cancellation
9466e29 Re-Added the TaskExecution abstraction to help in managing the current task runner and task cancellation
cd5c329 Added timeoutable tasks
683a812 Added timeoutable tasks
7c59cf1 extended docmentation with synchronous value access
016ef53 rename valueTimeout: -> synchronizeTimeout:
2dcb3cb rename valueTimeout: -> synchronizeTimeout:
8b861f8 - Refactored the runner hierarchy   - TKTAbstractWorker is not a runner anymore    - TKTAbstractWorker -> TKTQueueTaskScheduler   - TKTAbstractExecutor has the #exceptionHandler accessors- Added comments on every class- Fixed method categorization
ca4907d - Refactored the runner hierarchy   - TKTAbstractWorker is not a runner anymore    - TKTAbstractWorker -> TKTQueueTaskScheduler   - TKTAbstractExecutor has the #exceptionHandler accessors- Added comments on every class- Fixed method categorization
5863974 Testing that Worker process is terminated after GC
bda34e9 Workers are stopped once the worker scheduler is collected
55e47c7 - Extracted Traits TScheduler and TExecutor - Separated worker and worker thread to allow for collection in the future
1f21cb9 - Extracted Traits TScheduler and TExecutor - Separated worker and worker thread to allow for collection in the future
b5cc4d2 removed obsolete classes
1eb1eb4 removed obsolete classes
53afbe5 removed unused packages
67186ee fixed little typos
b26b4fa Merging TaskItPool tests into TaskIT tests
3042b0e Joined TKTWorkerPool into base package.
ba6418e all valuables are tasks -> all valuables can be tasks
22989f6 fixed comment on synchronous retrieval and added section on valuables as tasks
7ae80cd Made default runner in syntax sugared tasks the current task runner (which in turn defaults into the global worker pool if none)
022772f Default task running- current task runner is held in a process local variable- syntax sugar Futures run in a current task runner- future callbacks run in future runner to allow correct scheduling of callbacks- default task runner is global workpoolFixes in workpool- worker pool has a name- fixed worker pool stopping (should stop inner workers and reset size)
da3dea3 Default task running- current task runner is held in a process local variable- syntax sugar Futures run in a current task runner- future callbacks run in future runner to allow correct scheduling of callbacks- default task runner is global workpoolFixes in workpool- worker pool has a name- fixed worker pool stopping (should stop inner workers and reset size)
44a5b3c Default task running- current task runner is held in a process local variable- syntax sugar Futures run in a current task runner- future callbacks run in future runner to allow correct scheduling of callbacks- default task runner is global workpoolFixes in workpool- worker pool has a name- fixed worker pool stopping (should stop inner workers and reset size)
38c6460 Default task running- current task runner is held in a process local variable- syntax sugar Futures run in a current task runner- future callbacks run in future runner to allow correct scheduling of callbacks- default task runner is global workpoolFixes in workpool- worker pool has a name- fixed worker pool stopping (should stop inner workers and reset size)
a662d4f Default task running- current task runner is held in a process local variable- syntax sugar Futures run in a current task runner- future callbacks run in future runner to allow correct scheduling of callbacks- default task runner is global workpoolFixes in workpool- worker pool has a name- fixed worker pool stopping (should stop inner workers and reset size)
d935584 removed unused parts of the readme
5f001ca added combinators
2306757 wrote about exception management
5c6e1ec pass up to workers
20fe98f pass until new process task runner
60c10c6 pass on futures section
6a7c21c pass on first section
8bc9bc2 pass on readme structure
613129e recovered book chapter as readme documentation
8cfc40f Added Future combinators
617b491 Added Future combinators
44c5aa5 removed duplicated packages not managed by iceBerg
b1b0589 Importing package TaskIT2Services-Tests
9e4d0fe Importing package TaskIT2-Tests
7505883 Extracted process creation in TKTProcessProvider
605ef89 Extracted process creation in TKTProcessProvider
7e20c6e - Fixed exception handling in runners- Added Service manager
63584c8 - Fixed exception handling in runners- Added Service manager
26ec28b Adding exception handling in runners
5d7113f Importing package TaskIT2WorkerPool-Tests
4fffd06 Importing package TaskIT2Processes-Tests
3900799 Importing package TaskIT2Jobs-Tests
844a839 Importing package TaskIT2Collections-Tests
a17a1f2 - Splitted TaskIT packages between basic packages and extras- Added worker- Added worker pool- Added services
96887f0 - Splitted TaskIT packages between basic packages and extras- Added worker- Added worker pool- Added services
b088d17 Importing package TaskIT2WorkerPool
3107395 Importing package TaskIT2Tests-WorkerPool
e71ffe3 Importing package TaskIT2Examples
42eed99 Importing package TaskIT2Collections
a60db3d Importing package TaskIT2Tests-Core
78d72f8 Importing package TaskIT2Tests-Process
32cb6ca Importing package TaskIT2Services
8309a87 Importing package TaskIT2Processes
5ab0735 Importing package TaskIT2Jobs
b0b1a01 Importing package TaskIT2Jobs
4313b63 (tag: v0.1, origin/dev-0.1) Baseline :)
55e871e Piping the stdout/stderr streams to temp
65bf269 Squeaksource
eb1b3da Removing some tests that doesnt make sense any more
89a6938 Enhance the process browser :)
701aaba Some catalog data
2e6070a WhenFinished:
719bf14 Baseline!
e7758ff Update README.md
e5c7521 Create README.md
e67ad2c empty log message
dd1852a empty log message
f3cc110 Test memory leaks.
a118c1b debugging
d57cf20 Pushing to git as well
a414b77 Debugging
b381adb  Sandbox 1
c315d07  Sandbox 1
