#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	double x=0.6;
	double r;
	int npoints;
	int niterations;
	int i;

	if (argc!=4) {
		fprintf(stderr,"Usage: %s r numpoints niter\n",argv[0]);
		return EXIT_FAILURE;
	}
	r=atof(argv[1]);
	npoints=atoi(argv[2]);
	niterations=atoi(argv[3]);
	for (i=0;i<niterations;i++) {
		x=r*x*(1-x);
	}
	for (i=0;i<npoints;i++) {
		fprintf(stdout,"%12.6lf\n",x);
		x=r*x*(1-x);
	}
	fprintf(stdout,"\n");
	return EXIT_SUCCESS;
}
