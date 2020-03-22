defmodule Servy.VideoCam do
  @doc """
  Simulates sending a request to an external API
  to get snapshot image from a video camera
  """
  def get_snapshot(camera_name) do
    # CODE GOES HERE TO SEND A REQUEST TO AN EXTERNAL API
    #
    # sleep for one second to simulate that the API can be slow:
    :timer.sleep(1000)

    # example response returned from the API:
    "#{camera_name}-snapshot-#{:rand.uniform(1000)}.jpg"
  end
end
