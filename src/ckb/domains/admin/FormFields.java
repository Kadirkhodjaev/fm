package ckb.domains.admin;


import ckb.domains.GenId;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "Form_Fields")
public class FormFields extends GenId {
  // Форма
  @OneToOne
  @JoinColumn(name="Form_Id", nullable = false)
  private Forms form;

  // Поля
  @Column(length = 512)
  private String field;
  // Код поля
  @Column
  private String fieldCode;

  // CSS класс
  @Column
  private String cssClass;
  // Тип
  /**
   * text - текстовый
   * select - selectbox
   * textarea - textarea
   * **/
  @Column
  private String fieldType;
  // Максимальное кол-во символов
  @Column
  private int maxLength = 32;
  // Значение по умолчанию
  @Column
  private String defVal;
  @Column
  private int textCols;
  @Column
  private int textRows;
  @Column
  private String cssStyle;
  @Column
  private String resFlag;
  @Column // Единица измерения
  private String EI;
  @Column // Сохранить данные ввода
  private String save_val;
  @Column
  private String normaFrom;
  @Column
  private String normaTo;
  @Column
  private Integer ord;

  // Значении
  @ManyToMany(fetch = FetchType.EAGER)
  @JoinTable(name="Form_Field_Opts")
  private List<SelOpts> opts;

  public Forms getForm() {
    return form;
  }

  public void setForm(Forms formId) {
    this.form = formId;
  }

  public String getField() {
    return field;
  }

  public void setField(String field) {
    this.field = field;
  }

  public List<SelOpts> getOpts() {
    return opts;
  }

  public void setOpts(List<SelOpts> opts) {
    this.opts = opts;
  }

  public String getFieldCode() {
    return fieldCode;
  }

  public void setFieldCode(String fieldCode) {
    this.fieldCode = fieldCode;
  }

  public String getCssClass() {
    return cssClass;
  }

  public void setCssClass(String cssClass) {
    this.cssClass = cssClass;
  }

  public String getFieldType() {
    return fieldType;
  }

  public void setFieldType(String fieldType) {
    this.fieldType = fieldType;
  }

  public int getMaxLength() {
    return maxLength;
  }

  public void setMaxLength(int maxLength) {
    this.maxLength = maxLength;
  }

  public String getDefVal() {
    return defVal;
  }

  public void setDefVal(String defVal) {
    this.defVal = defVal;
  }

  public int getTextCols() {
    return textCols;
  }

  public void setTextCols(int textCols) {
    this.textCols = textCols;
  }

  public int getTextRows() {
    return textRows;
  }

  public void setTextRows(int textRows) {
    this.textRows = textRows;
  }

  public String getCssStyle() {
    return cssStyle;
  }

  public void setCssStyle(String cssStyle) {
    this.cssStyle = cssStyle;
  }

  public String getResFlag() {
    return resFlag;
  }

  public void setResFlag(String resFlag) {
    this.resFlag = resFlag;
  }

  public String getEI() {
    return EI;
  }

  public void setEI(String EI) {
    this.EI = EI;
  }

  public String getSave_val() {
    return save_val;
  }

  public void setSave_val(String save_val) {
    this.save_val = save_val;
  }

  public String getNormaFrom() {
    return normaFrom;
  }

  public void setNormaFrom(String normaFrom) {
    this.normaFrom = normaFrom;
  }

  public String getNormaTo() {
    return normaTo;
  }

  public void setNormaTo(String normaTo) {
    this.normaTo = normaTo;
  }

  public Integer getOrd() {
    return ord;
  }

  public void setOrd(Integer ord) {
    this.ord = ord;
  }
}
