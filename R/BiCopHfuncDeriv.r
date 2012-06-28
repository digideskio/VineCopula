BiCopHfuncDeriv<-function(u1,u2,family,par,par2=0,deriv="par")
{
	if(is.null(u1)==TRUE || is.null(u2)==TRUE) stop("u1 and/or u2 are not set or have length zero.")
	if(length(u1)!=length(u2)) stop("Lengths of 'u1' and 'u2' do not match.")
	if(any(u1>1) || any(u1<0)) stop("Data has be in the interval [0,1].")
  if(any(u2>1) || any(u2<0)) stop("Data has be in the interval [0,1].")
	if(!(family %in% c(0,1,2,3,4,5,6,13,14,16,23,24,26,33,34,36))) stop("Copula family not implemented.")
	if(family==2 && par2==0) stop("For t-copulas, 'par2' must be set.")
	if(c(1,3,4,5,6,13,14,16,23,24,26,33,34,36) %in% family && length(par)<1) stop("'par' not set.")
	
	if((family==1 || family==2) && abs(par[1])>=1) stop("The parameter of the Gaussian and t-copula has to be in the interval (-1,1).")
	if(family==2 && par2<=2) stop("The degrees of freedom parameter of the t-copula has to be larger than 2.")
	if((family==3 || family==13) && par<=0) stop("The parameter of the Clayton copula has to be positive.")
	if((family==4 || family==14) && par<1) stop("The parameter of the Gumbel copula has to be in the interval [1,oo).")
	if((family==6 || family==16) && par<=1) stop("The parameter of the Joe copula has to be in the interval (1,oo).")
	if(family==5 && par==0) stop("The parameter of the Frank copula has to be unequal to 0.")
	if((family==23 || family==33) && par>=0) stop("The parameter of the rotated Clayton copula has to be negative.")
	if((family==24 || family==34) && par>-1) stop("The parameter of the rotated Gumbel copula has to be in the interval (-oo,-1].")
	if((family==26 || family==36) && par>=-1) stop("The parameter of the rotated Joe copula has to be in the interval (-oo,-1).")

	if(deriv=="par2" &&  family!=2) stop("The derivative with respect to the second parameter can only be derived for the t-copula.")

	# Unterscheidung in die verschiedenen Ableitungen
	
	n=length(u1)
	
	if(deriv=="par")
	{
		if(family==2)
		{
			out <- .C("diffhfunc_rho_tCopula",
				      as.double(u1),
				      as.double(u2),
				      as.integer(n),
				      as.double(c(par,par2)),
				      as.integer(2),
				      as.double(rep(0,n)),
					PACKAGE = 'VineCopula')[[6]]
		}
		else
		{
			out <- .C("diffhfunc_mod",
				      as.double(u1),
				      as.double(u2),
				      as.integer(n),
				      as.double(par),
				      as.integer(family),
				      as.double(rep(0,n)),
					PACKAGE = 'VineCopula')[[6]]
		}
	}
	else if(deriv=="par2")
	{
		out <- .C("diffhfunc_nu_tCopula_new",
			as.double(u1),
			as.double(u2),
			as.integer(n),
			as.double(c(par,par2)),
			as.integer(2),
			as.double(rep(0,n)),
			PACKAGE = 'VineCopula')[[6]]
	}
	else if(deriv=="u2")
	{
		out <- .C("diffhfunc_v_mod",
		      as.double(u1),
		      as.double(u2),
		      as.integer(n),
		      as.double(c(par,par2)),
		      as.integer(family),
		      as.double(rep(0,n)),
			PACKAGE = 'VineCopula')[[6]]
	}
	else
	{
		stop("This kind of derivative is not implemented")
	}

return(out)
}

