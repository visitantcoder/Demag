function style = wscn_style(mode)
style.Mode=lower(mode);

if strcmpi(mode,'paper')
    style.FontName='Times New Roman';
    style.FontSize=8.3;
    style.SmallFont=7.4;
    style.TitleFont=9.2;
    style.LineWidth=1.20;
    style.MarkerSize=4.8;
    style.AxesLineWidth=0.75;

    % Approximately 180 mm wide: suitable for a two-column paper figure.
    style.ProcessSize=[7.10 6.85];
    style.EnergySize=[7.10 2.75];

    % CAP-CSDP result figures.
    style.CAPRGBSize=[7.10 4.75];
    style.CAPChannelSize=[7.10 4.15];

    style.PNGResolution=600;
    style.ShowSuperTitle=false;
else
    style.FontName='Arial';
    style.FontSize=14;
    style.SmallFont=12;
    style.TitleFont=16;
    style.LineWidth=2.0;
    style.MarkerSize=7.0;
    style.AxesLineWidth=1.0;

    style.ProcessSize=[10.8 9.1];
    style.EnergySize=[12.8 4.45];

    style.CAPRGBSize=[11.6 7.4];
    style.CAPChannelSize=[13.0 7.4];

    style.PNGResolution=300;
    style.ShowSuperTitle=true;
end
end
