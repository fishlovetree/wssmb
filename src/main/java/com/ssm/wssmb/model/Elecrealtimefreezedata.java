package com.ssm.wssmb.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

public class Elecrealtimefreezedata {
	
	private String gasconcentration;

	private String barometricPressure;
	
	private Integer id;

	private Integer equipmentType;

	private String equipmentAddress;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 前端时间字符串转java时间戳
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") // 后台时间戳转前端时间字符串(json对象)
	private Date freezetime;

	private int positiveelectricity;

	private int positiveelectricitya;

	private int positiveelectricityb;

	private int positiveelectricityc;

	private int reverseelectricity;

	private int reverseelectricitya;

	private int reverseelectricityb;

	private int reverseelectricityc;

	private int voltagea;

	private int voltageb;

	private int voltagec;

	private int cueeenta;

	private int cueeentb;

	private int cueeentc;
	
	private int residualcueeent;

	private int power;

	private int powera;

	private int powerb;

	private int powerc;

	private int pf;

	private int pfa;

	private int pfb;

	private int pfc;

	private int frequency;

	private int temperaturea;

	private int temperatureb;

	private int temperaturec;

	private int temperaturen;

	private int ambienttemperature;

	private int internalbatteryvoltage;

	private int externalbatteryvoltage;
	
	private String humidness;
	
	private String error;	

	public String getGasconcentration() {
		return gasconcentration;
	}

	public void setGasconcentration(String gasconcentration) {
		this.gasconcentration = gasconcentration;
	}

	public String getHumidness() {
		return humidness;
	}

	public void setHumidness(String humidness) {
		this.humidness = humidness;
	}

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getEquipmentType() {
		return equipmentType;
	}

	public void setEquipmentType(Integer equipmentType) {
		this.equipmentType = equipmentType;
	}

	public String getEquipmentAddress() {
		return equipmentAddress;
	}

	public void setEquipmentAddress(String equipmentAddress) {
		this.equipmentAddress = equipmentAddress;
	}

	public Date getFreezetime() {
		return freezetime;
	}

	public void setFreezetime(Date freezetime) {
		this.freezetime = freezetime;
	}

	public int getPositiveelectricity() {
		return positiveelectricity;
	}

	public void setPositiveelectricity(int positiveelectricity) {
		this.positiveelectricity = positiveelectricity;
	}

	public int getPositiveelectricitya() {
		return positiveelectricitya;
	}

	public void setPositiveelectricitya(int positiveelectricitya) {
		this.positiveelectricitya = positiveelectricitya;
	}

	public int getPositiveelectricityb() {
		return positiveelectricityb;
	}

	public void setPositiveelectricityb(int positiveelectricityb) {
		this.positiveelectricityb = positiveelectricityb;
	}

	public int getPositiveelectricityc() {
		return positiveelectricityc;
	}

	public void setPositiveelectricityc(int positiveelectricityc) {
		this.positiveelectricityc = positiveelectricityc;
	}

	public int getReverseelectricity() {
		return reverseelectricity;
	}

	public void setReverseelectricity(int reverseelectricity) {
		this.reverseelectricity = reverseelectricity;
	}

	public int getReverseelectricitya() {
		return reverseelectricitya;
	}

	public void setReverseelectricitya(int reverseelectricitya) {
		this.reverseelectricitya = reverseelectricitya;
	}

	public int getReverseelectricityb() {
		return reverseelectricityb;
	}

	public void setReverseelectricityb(int reverseelectricityb) {
		this.reverseelectricityb = reverseelectricityb;
	}

	public int getReverseelectricityc() {
		return reverseelectricityc;
	}

	public void setReverseelectricityc(int reverseelectricityc) {
		this.reverseelectricityc = reverseelectricityc;
	}

	public int getVoltagea() {
		return voltagea;
	}

	public void setVoltagea(int voltagea) {
		this.voltagea = voltagea;
	}

	public int getVoltageb() {
		return voltageb;
	}

	public void setVoltageb(int voltageb) {
		this.voltageb = voltageb;
	}

	public int getVoltagec() {
		return voltagec;
	}

	public void setVoltagec(int voltagec) {
		this.voltagec = voltagec;
	}

	public int getCueeenta() {
		return cueeenta;
	}

	public void setCueeenta(int cueeenta) {
		this.cueeenta = cueeenta;
	}

	public int getCueeentb() {
		return cueeentb;
	}

	public void setCueeentb(int cueeentb) {
		this.cueeentb = cueeentb;
	}

	public int getCueeentc() {
		return cueeentc;
	}

	public void setCueeentc(int cueeentc) {
		this.cueeentc = cueeentc;
	}

	public int getResidualcueeent() {
		return residualcueeent;
	}

	public void setResidualcueeent(int residualcueeent) {
		this.residualcueeent = residualcueeent;
	}

	public int getPower() {
		return power;
	}

	public void setPower(int power) {
		this.power = power;
	}

	public int getPowera() {
		return powera;
	}

	public void setPowera(int powera) {
		this.powera = powera;
	}

	public int getPowerb() {
		return powerb;
	}

	public void setPowerb(int powerb) {
		this.powerb = powerb;
	}

	public int getPowerc() {
		return powerc;
	}

	public void setPowerc(int powerc) {
		this.powerc = powerc;
	}

	public int getPf() {
		return pf;
	}

	public void setPf(int pf) {
		this.pf = pf;
	}

	public int getPfa() {
		return pfa;
	}

	public void setPfa(int pfa) {
		this.pfa = pfa;
	}

	public int getPfb() {
		return pfb;
	}

	public void setPfb(int pfb) {
		this.pfb = pfb;
	}

	public int getPfc() {
		return pfc;
	}

	public void setPfc(int pfc) {
		this.pfc = pfc;
	}

	public int getFrequency() {
		return frequency;
	}

	public void setFrequency(int frequency) {
		this.frequency = frequency;
	}

	public int getTemperaturea() {
		return temperaturea;
	}

	public void setTemperaturea(int temperaturea) {
		this.temperaturea = temperaturea;
	}

	public int getTemperatureb() {
		return temperatureb;
	}

	public void setTemperatureb(int temperatureb) {
		this.temperatureb = temperatureb;
	}

	public int getTemperaturec() {
		return temperaturec;
	}

	public void setTemperaturec(int temperaturec) {
		this.temperaturec = temperaturec;
	}

	public int getTemperaturen() {
		return temperaturen;
	}

	public void setTemperaturen(int temperaturen) {
		this.temperaturen = temperaturen;
	}

	public int getAmbienttemperature() {
		return ambienttemperature;
	}

	public void setAmbienttemperature(int ambienttemperature) {
		this.ambienttemperature = ambienttemperature;
	}

	public int getInternalbatteryvoltage() {
		return internalbatteryvoltage;
	}

	public void setInternalbatteryvoltage(int internalbatteryvoltage) {
		this.internalbatteryvoltage = internalbatteryvoltage;
	}

	public int getExternalbatteryvoltage() {
		return externalbatteryvoltage;
	}

	public void setExternalbatteryvoltage(int externalbatteryvoltage) {
		this.externalbatteryvoltage = externalbatteryvoltage;
	}

	public String getBarometricPressure() {
		return barometricPressure;
	}

	public void setBarometricPressure(String barometricPressure) {
		this.barometricPressure = barometricPressure;
	}

	@Override
	public String toString() {
		return "Elecrealtimefreezedata [barometricPressure=" + barometricPressure + ", id=" + id + ", equipmentType="
				+ equipmentType + ", equipmentAddress=" + equipmentAddress + ", freezetime=" + freezetime
				+ ", positiveelectricity=" + positiveelectricity + ", positiveelectricitya=" + positiveelectricitya
				+ ", positiveelectricityb=" + positiveelectricityb + ", positiveelectricityc=" + positiveelectricityc
				+ ", reverseelectricity=" + reverseelectricity + ", reverseelectricitya=" + reverseelectricitya
				+ ", reverseelectricityb=" + reverseelectricityb + ", reverseelectricityc=" + reverseelectricityc
				+ ", voltagea=" + voltagea + ", voltageb=" + voltageb + ", voltagec=" + voltagec + ", cueeenta="
				+ cueeenta + ", cueeentb=" + cueeentb + ", cueeentc=" + cueeentc + ", residualcueeent="
				+ residualcueeent + ", power=" + power + ", powera=" + powera + ", powerb=" + powerb + ", powerc="
				+ powerc + ", pf=" + pf + ", pfa=" + pfa + ", pfb=" + pfb + ", pfc=" + pfc + ", frequency=" + frequency
				+ ", temperaturea=" + temperaturea + ", temperatureb=" + temperatureb + ", temperaturec=" + temperaturec
				+ ", temperaturen=" + temperaturen + ", ambienttemperature=" + ambienttemperature
				+ ", internalbatteryvoltage=" + internalbatteryvoltage + ", externalbatteryvoltage="
				+ externalbatteryvoltage + ", humidness=" + humidness + ", error=" + error + "]";
	}

}
