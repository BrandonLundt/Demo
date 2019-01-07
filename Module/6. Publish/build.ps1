Register-PSRepository -Name "Local" -PublishLocation C:\Users\brandon.lundt\Documents

Publish-Module -Name MonoModule -Repository "Local"