local WindowsList

WindowsList=info("windows")

//make this ntoice that we're in comments linked but I
//don't remember why?

loop
orderline=str(IDNumber)+¬+str(Item)+¬+Description+¬+str(«Sz.»)+¬+str(«44cost»)+¬+orderquantity+¬+str(int(«44available»))+¬+SupplierID+¶
;bigmessage orderline
forordering=forordering+orderline
;bigmessage forordering
downrecord
until info("stopped")

clipboard()=forordering

orderline=str(IDNumber)+¬+str(Item)+¬+Description+¬+str(«Sz.»)+¬+str(«44cost»)+¬+orderquantity+¬+str(int(«44available»))+¬+SupplierID+¶

orderline arrayed into forordering=
800062	3212-A	Mask, N95 VFlex 9105 3M - Box of 50	Box	24.06	1	0	0
99510	8545-A	Vermi-tox	3	36.00	1	21	
90740	8862-B	Orchard Netting 14x14'	0	4.96	1	109	BN-2
90740	8862-B	Orchard Netting 14x14'	0	4.96	1	109	BN-2
90750	8862-C	Orchard Netting 28x28'	2	19.38	1	203	BN-3
90760	8865-A	Deer X Fencing 7x100'	0	12.78	1	92	DX-7
90770	8865-B	Deer X Fencing 14x75'	2	19.66	1	234	DX-14
90740	8862-B	Orchard Netting 14x14'	0	4.96	1	109	BN-2
90750	8862-C	Orchard Netting 28x28'	2	19.38	1	203	BN-3
90760	8865-A	Deer X Fencing 7x100'	0	12.78	1	92	DX-7
90770	8865-B	Deer X Fencing 14x75'	2	19.66	1	234	DX-14

arrayfilter forordering, intorder, ¶, extract(extract(forordering, ¶, seq()),¬, 1)+¬+extract(extract(forordering, ¶, seq()),¬, 2)+¬+
    extract(extract(forordering, ¶, seq()),¬, 3)+¬+extract(extract(forordering, ¶, seq()),¬, 4)+¬+
    extract(extract(forordering, ¶, seq()),¬, 5)+¬+extract(extract(forordering, ¶, seq()),¬, 6)+¬+
    extract(extract(forordering, ¶, seq()),¬, 7)+¬+¬+¬+¬+extract(extract(forordering, ¶, seq()),¬, 8)

filtered to intorder=
800062	3212-A	Mask, N95 VFlex 9105 3M - Box of 50	Box	24.06	1	0				0
99510	8545-A	Vermi-tox	3	36.00	1	21				
90740	8862-B	Orchard Netting 14x14'	0	4.96	1	109				BN-2
90740	8862-B	Orchard Netting 14x14'	0	4.96	1	109				BN-2
90750	8862-C	Orchard Netting 28x28'	2	19.38	1	203				BN-3
90760	8865-A	Deer X Fencing 7x100'	0	12.78	1	92				DX-7
90770	8865-B	Deer X Fencing 14x75'	2	19.66	1	234				DX-14
90740	8862-B	Orchard Netting 14x14'	0	4.96	1	109				BN-2
90750	8862-C	Orchard Netting 28x28'	2	19.38	1	203				BN-3
90760	8865-A	Deer X Fencing 7x100'	0	12.78	1	92				DX-7
90770	8865-B	Deer X Fencing 14x75'	2	19.66	1	234				DX-14

