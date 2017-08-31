# Deploying the Infrastructure with Terraform

- After getting the terraform templates ready check if everything is OK or not

```
# terraform plan
```

- If we want the graph of our architechture we can use the following. Please ensure that you have `dot` installed on your machine. `dot` helps to generate graphs.

```
# terraform graph | dot -Tpng > graph.png
```

- Now if you feel everything is ready to deploy then apply the terraform config

```
# terraform apply
```
