

***SQL Server & Continuous Integration***
<br>
James Anderson
<br>
www.TheDatabaseAvenger.com
<br>
@DatabaseAvenger
<br>
James@TheSQLPeople.com

http://thedatabaseavenger.com/2016/07/sql-server-and-continuous-integration/

---

What is CI?


<br>
It's not just a suite of tools<!-- .element: class="fragment" -->

<br>
Moving quickly from ideas to production
<!-- .element: class="fragment" -->

<br>
Continually integrating
<!-- .element: class="fragment" -->

---

What do I need for CI?


<br>
Team buy in<!-- .element: class="fragment" -->


<br>
Tools<!-- .element: class="fragment" -->

---

You don't need the Ferrari of build servers

![Image](./assets/img/Ferrari.jpg)

---

You can still get there for less

![Image](./assets/img/allegro.jpg)

---

What can stop us?


<br>
Slow cycles<!-- .element: class="fragment" -->


* Approvals<!-- .element: class="fragment" -->
* Manual Testing<!-- .element: class="fragment" -->
* Low buy in<!-- .element: class="fragment" -->

---

Why is deploying database changes so difficult?

---

State based Vs Migration based

---

The Hybrid Approach


![Image](./assets/img/RedgateReadyRoll.jpg)

---

ReadyRoll Demo

+++

![Image](./assets/img/ReadyRoll/Create new ReadyRoll project.png)

+++

![Image](./assets/img/ReadyRoll/Connect to local SQL Server instance.png)

+++

![Image](./assets/img/ReadyRoll/Connect to database.png)

+++

![Image](./assets/img/ReadyRoll/Deploy new ReadyRoll project.png)

+++

![Image](./assets/img/ReadyRoll/Import database.png)

+++

![Image](./assets/img/ReadyRoll/Connect to database 2.png)

+++

![Image](./assets/img/ReadyRoll/Importing database.png)

+++

![Image](./assets/img/ReadyRoll/ReadyRoll migration log and shadow database.png)

+++

![Image](./assets/img/ReadyRoll/ReadyRoll config settings.png)


http://thedatabaseavenger.com/2016/10/starting-a-readyroll-project/

+++

![Image](./assets/img/ReadyRoll/ReadyRoll offline schema model.png)

+++

![Image](./assets/img/ReadyRoll/Add 2 tables and 1 SP to ReadyRoll database.png)

+++

![Image](./assets/img/ReadyRoll/ReadyRoll migration log columns.png)

---

GitLab


![Image](./assets/img/gitlab.png)

---

GitLab Features

<br>
* Remote repository
* Build server with CI pipelines
* Issue management \ Bug tracking
* Documentation (I love this)

---

GitLab Demo

---

Tests

<br>
* tSQLt
* Pester
* Docker

---

Run the Tests Demo

---

So now we have automatic testing everytime we make a change.



All is good<!-- .element: class="fragment" -->



But...<!-- .element: class="fragment" -->

---

Test the project against all versions of SQL Server

---

![Image](./assets/img/docker.png)

---

Run Tests Against Containers Demo

---

Thanks for listening
<br>
<br>
Any questions?
<br>
<br>
www.TheDatabaseAvenger.com
<br>
@DatabaseAvenger
<br>
James@TheSQLPeople.com
