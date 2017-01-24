## Ansible Skeleton

**Reasoning**

Ansible's big selling point is managing many, many machines at once. It's great, but overkill for the daily developer. This skeleton shows how you can structure Ansible source files to work from the point of view of someone who is only ever focused on one project at a time. It's the starting point for everything you're working on from local to remote. If you have 10 projects, all the details for all 10 projects are kept in this repository. 

Fork this project to customize your build and deploy process. 

**Features**

* One-stop-shop for developement to deployment workflow on a LEMP stack.
* Role-based Ansible. By keeping all tasks primarily in roles (and nested roles), we can be more in control of the order of operations.
* Encrypted passwords. Passwords are kept in encrypted files using ansible-vault. For now, we just store the encryption password in a file on your local setup to avoid having to re-type it every time.
* Vagrant for development.

**Requirements**

* ansible 2.1+
* virtualbox
* vagrant

**Setup**

1. Set the `ansible-vault` encryption key

    ```
    echo "test123" > vault
    ```

1. Install ansible dependencies:

    ```
    ansible-galaxy install -r galaxy/requirements.txt
    ```

1. Clone your project to `~/projects/ansible/` where vagrant can find it. The directory of your project should match the "app_name" variable you'll use throughout. (For example, if your project is called demonstration, but you want to reference it as "demo" then you should name the directory "demo".)

1. Spin up the vagrant project:

    ```
    vagrant up demo
    ```
    
**Build**

The build script installs the necessary software for your local or remote machine. 

```
ansible-playbook -i hosts/demo/dev --ask-sudo-pass books/build.yml
```

