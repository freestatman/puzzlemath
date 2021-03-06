testthat::context("testing startup reactivity")

# We run a test with the expectation that the hist tag will be triggered once.

driver_commands_startup <- quote({
  
  # wait for input$n element to be created
  el_game <- reactor::wait(
    test_driver = test_driver,
    expr = test_driver$client$findElement(using = 'id', value = 'game')
  )
  
  el_game$clickElement()
  
  el_draw <- reactor::wait(
    test_driver = test_driver,
    expr = test_driver$client$findElement(using = 'id', value = 'draw')
  )
  
  el_draw$clickElement()
  
})

driver_commands_draw <- quote({

  el_draw <- reactor::wait(
    test_driver = test_driver,
    expr = test_driver$client$findElement(using = 'id', value = 'draw')
  )
  
  el_draw$clickElement()
  
})

testthat::describe('startup',{

  click_counter <- reactor::test_reactor(
    expr          = driver_commands_startup,
    test_driver   = reactor::firefox_driver(),
    processx_args = reactor::golem_args()
  )
  
  it('reactivity at startup',{
    reactor::expect_reactivity(object = click_counter, tag = 'plot',count =  1)
  })
  
  it('reactivity first draw',{
    reactor::expect_reactivity(object = click_counter, tag = 'draw',count =  4)
  })
  
})

testthat::describe('draw',{
  
  click_counter <- reactor::test_reactor(
    expr          = driver_commands_draw,
    test_driver   = reactor::firefox_driver(),
    processx_args = reactor::golem_args()
  )
  
  it('reactivity first draw',{
    reactor::expect_reactivity(object = click_counter, tag = 'draw',count =  2)
  })
  
})
