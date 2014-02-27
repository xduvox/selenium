require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"

class Promo < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://promodescuentos.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
  def test_promo
    @driver.get(@base_url + "/")
    @driver.find_element(:link, "Best Buy").click
    @driver.find_element(:link, "Best Buy: Nexus 7 (2012) 32GB $2,740 y envío gratis en toda la tienda").click
    verify { assert_equal "Best Buy: Nexus 7 (2012) 32GB $2,740 y envío gratis en toda la tienda", @driver.find_element(:css, "h2").text }
    @driver.find_element(:link, "Viajes").click
    @driver.find_element(:link, "Promociones aniversario Volaris 2014: 31 días de regalos").click
    verify { assert_equal "Promociones aniversario Volaris 2014: 31 días de regalos", @driver.find_element(:css, "h2").text }
  end
  
  def element_present?(how, what)
    $receiver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    $receiver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = $receiver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
