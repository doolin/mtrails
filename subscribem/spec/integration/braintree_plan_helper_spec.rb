require "rails_helper"
require "subscribem/braintree_plan_fetcher"

describe Subscribem::BraintreePlanFetcher do
  let(:faux_plan) do
    double("Plan",
           :id    => "faux1",
           :name  => "Starter",
           :price => "9.95")
  end

  it "fetches and stores plans" do
    expect(Braintree::Plan).to receive(:all).and_return([faux_plan])
    expect(Subscribem::Plan).to receive(:create).with({
      :braintree_id => "faux1",
      :name         => "Starter",
      :price        => "9.95"
    })
    Subscribem::BraintreePlanFetcher.store_locally
  end
end
