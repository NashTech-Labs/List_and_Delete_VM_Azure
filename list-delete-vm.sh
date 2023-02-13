#!/bin/bash

echo "List of VM's"
az vm list -d -o table

az vm list -d -o table | sed 's/\|/ /'|awk '{print $1}' | awk '/^Name|^-----|^Name/ {next}{for (i=1;i<=NF;i++){print $i}}' > vm-list.txt

echo "Enter VM Name:"
read vmname

echo "====Checking VM exists or not====="
  if grep -w -i $vmname vm-list.txt
   then
     echo "Hooray!!It's available"
    az vm list -d -o table | sed 's/\|/ /'|awk '{print $2}' | awk '/^ResourceGroup|^-----|^Name/ {next}{for (i=1;i<=NF;i++){print $i}}' > rg-list.txt

    echo "Please Enter the resource group name to delete the VM:"
    read rgname
    echo "====Checking ResourceGroup exists or not====="

        if grep -w -i $rgname rg-list.txt
        then
        az vm delete --resource-group $rgname --name $vmname
        echo "Deleted RG and VM"
        rm rg-list.txt vm-list.txt
        else
        echo "Oops!!ResourceGroup not available"
        rm rg-list.txt vm-list.txt
        fi
    else
    echo "Oops!!VM not available"
    rm vm-list.txt
fi
