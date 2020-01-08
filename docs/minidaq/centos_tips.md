## Downgrade a package
If we want to downgrade a package to a previous highest version that is
available in a remote repository, we can use the following command:
```
sudo yum downgrade <package_name>
```


## Pinning a package to current version
We use `yum-plugin-versionlock`. Install that if it's not already installed:
```
sudo yum install yum-plugin-versionlock
```

To pin a package to its current version so that no automatic update will be
performed on that package, issue the following command:
```
sudo yum versionlock <package_name>
```

To display locked packages:
```
sudo yum versionlock list
```

To discard the list:
```
sudo yum versionlock clear
```
