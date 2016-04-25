Docker image with Chef solo
=============================================

This is demo image based on Debian that uses Chef-solo to deploy and configure apahce2 to redirect http traffic to https and serve example greeting page.
## Example usage:
````
docker run -d -p 80:80 -p 443:443 izhekova/chef-demo
````

Upon starting a container you should be able to open the IP address of the host and be redirected to https:// where a greeting page will be displayed.
