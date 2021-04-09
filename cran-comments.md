## Test environments
- R-hub windows-x86_64-devel (r-devel,  env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always")
- R-hub fedora-clang-devel (r-devel)

No ERRORs, WARNINGs, or NOTEs. 

## R CMD check results
No ERRORs, WARNINGs, or NOTEs. 
  
## No dependency issues

* This minor patch fixes a hardcoded pattern in a gsub call that caused misleading outputs, and improves the wording in the respective documentation.
