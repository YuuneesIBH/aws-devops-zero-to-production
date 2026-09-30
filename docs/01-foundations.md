# 1. Computer and service foundations

A computer executes instructions on a CPU, keeps active data in RAM and persists data on storage. An operating system manages hardware and isolates processes. Its kernel schedules threads, controls memory and handles network and filesystem calls. A *process* is a running program with its own address space; threads share that process's memory. A filesystem maps paths such as `/var/log/app.log` to stored data. A network interface sends and receives packets.

A server is a program that listens for requests; a client initiates them. A web API defines a set of requests and responses. A frontend renders user interaction, a backend applies rules and a database persists data. A single machine can run all three, but separating them lets teams scale and secure each independently.

Infrastructure comprises compute, network, storage, identity and operational controls. Cloud providers expose these as APIs: creating a virtual machine is a request to a control plane, not a physical server appearing instantly. DevOps improves the path from code to reliable operation through shared ownership and automation. SRE uses reliability objectives and error budgets to make operational tradeoffs explicit. Platform engineering creates paved paths for teams, such as a standard deployment pipeline.

## Trace one request

Browser resolves a name, opens a TCP connection, negotiates TLS, sends HTTP, then waits. A reverse proxy routes the request to a backend. The backend may query a database. Each boundary can fail independently: DNS, route, firewall, port, TLS, application or data layer. Later chapters examine each.

## Knowledge check

1. Which data disappears on power loss: RAM or persistent storage?
2. Why can a process be running while its service is unavailable?
3. Draw client, API and database; mark the network hop and data at rest.

Further reading: [Linux kernel docs](https://docs.kernel.org/), [AWS cloud concepts](https://docs.aws.amazon.com/whitepapers/latest/aws-overview/introduction.html).
