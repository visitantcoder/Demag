function tensor = classifier_build_cap_tensor(src,ref,P)
Er=capcsdp_render_channel(src.Br,ref.Ar,P.CAP);
Et=capcsdp_render_channel(src.Bt,ref.At,P.CAP);
Ez=capcsdp_render_channel(src.Bz,ref.Az,P.CAP);

tensor=cat(3,Er,Et,Ez);
end
