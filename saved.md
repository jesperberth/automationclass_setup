# Saved bits

```yaml

    - name: Create Azure VM extension to extend /home on ansible
      azure.azcollection.azure_rm_virtualmachineextension:
        name: ansible-adddisk
        resource_group: "{{ resource_group }}"
        virtual_machine_name: ansible
        publisher: Microsoft.Azure.Extensions
        virtual_machine_extension_type: CustomScript
        type_handler_version: "2.1"
        settings: '{"commandToExecute": " lvm lvextend --size 20G /dev/rootvg/homelv && xfs_growfs /dev/mapper/rootvg-homelv", "skipDos2Unix": true}'
        auto_upgrade_minor_version: true
```