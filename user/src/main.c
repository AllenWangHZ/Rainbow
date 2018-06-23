#include "main.h"
#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "stm32f4xx_rcc.h"

void Delay(void);

int
main(void)
{
  GPIO_InitTypeDef GPIO_InitStruct;

  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA, ENABLE);

  GPIO_InitStruct.GPIO_Mode  = GPIO_Mode_OUT;
  GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStruct.GPIO_Pin   = GPIO_Pin_11 | GPIO_Pin_12;
  GPIO_InitStruct.GPIO_Speed = GPIO_Speed_100MHz;
  GPIO_InitStruct.GPIO_PuPd  = GPIO_PuPd_NOPULL;

  GPIO_Init(GPIOA, &GPIO_InitStruct);

  while(1) {
    GPIOA->BSRRH = GPIO_Pin_11;
    GPIOA->BSRRL = GPIO_Pin_12;
	Delay();
    GPIOA->BSRRL = GPIO_Pin_11;
    GPIOA->BSRRH = GPIO_Pin_12;
	Delay();
  }

  return 0;
}

void
Delay(void)
{
  unsigned int delayTime = 10000000;
  while(delayTime--);
}
